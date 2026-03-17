yea{ pkgs, lib, ... }:
let
  python = rec {
    defaultVersion = pkgs.python312;
    additionalVersions = with pkgs; [
      python311
    ];
    packages = ps: with ps; [
      pip
      virtualenv
    ];
    default = defaultVersion.withPackages packages;
    additional = map
      (py: lib.lowPrio (py.withPackages packages))
      additionalVersions;
  };
in
{
  home.packages = with pkgs; [
    direnv
    nixd
    tree-sitter
    python.default
  ] ++ python.additional;

  home.file."bin/feast" = lib.mkIf pkgs.stdenv.isDarwin {
    executable = true;
    text = ''
      #!/usr/bin/env -S uv run --script
      # /// script
      # requires-python = ">=3.12"
      # ///
      """GitLab Atom feed TUI viewer.

      Fetches the GitLab projects Atom feed and displays entries in an
      interactive terminal UI, allowing navigation and browser opening.

      Usage:
          feast
      """

      import curses
      import html
      import os
      import re
      import subprocess
      import textwrap
      import webbrowser
      from datetime import datetime
      from urllib.error import URLError
      from urllib.request import Request, urlopen
      from xml.etree import ElementTree

      FEED_TOKEN: str = os.environ.get("GITLAB_FEED_TOKEN", "")
      BASE_URL: str = os.environ.get("GITLAB_BASE_URL", "")

      FEED_SOURCES: dict[str, str] = {
          "projects": f"{BASE_URL}/projects.atom?feed_token={FEED_TOKEN}",
          "activity": f"{BASE_URL}/activity.atom?feed_token={FEED_TOKEN}",
      }

      ATOM_NAMESPACE: str = "{http://www.w3.org/2005/Atom}"


      class FeedEntry:
          """Represents a single Atom feed entry."""

          def __init__(
              self,
              title: str,
              link: str,
              updated: str,
              author: str,
              summary: str,
          ) -> None:
              self.title: str = title
              self.link: str = link
              self.updated: str = updated
              self.author: str = author
              self.summary: str = summary

          @property
          def display_date(self) -> str:
              """Format the updated timestamp for display."""
              try:
                  parsed_date = datetime.fromisoformat(
                      self.updated.replace("Z", "+00:00")
                  )
                  return parsed_date.strftime("%Y-%m-%d %H:%M")
              except (ValueError, AttributeError):
                  return self.updated[:16] if self.updated else "unknown"


      def strip_html_tags(text: str) -> str:
          """Remove HTML tags and decode entities from a string."""
          cleaned = re.sub(r"<[^>]+>", " ", text)
          cleaned = html.unescape(cleaned)
          cleaned = re.sub(r"\s+", " ", cleaned).strip()
          return cleaned


      def fetch_feed(feed_name: str = "activity") -> list[FeedEntry]:
          """Fetch and parse the Atom feed, returning a list of entries."""
          feed_url: str = FEED_SOURCES[feed_name]
          request = Request(
              feed_url, headers={"User-Agent": "gitlab-feed-tui/1.0"}
          )
          try:
              with urlopen(request, timeout=15) as response:
                  raw_data: bytes = response.read()
          except URLError as url_error:
              raise SystemExit(f"Failed to fetch feed: {url_error}") from url_error

          root = ElementTree.fromstring(raw_data)

          entries: list[FeedEntry] = []
          for entry_element in root.findall(f"{ATOM_NAMESPACE}entry"):
              title_element = entry_element.find(f"{ATOM_NAMESPACE}title")
              link_element = entry_element.find(f"{ATOM_NAMESPACE}link")
              updated_element = entry_element.find(f"{ATOM_NAMESPACE}updated")
              author_element = entry_element.find(f"{ATOM_NAMESPACE}author")
              summary_element = entry_element.find(f"{ATOM_NAMESPACE}summary")

              author_name: str = ""
              if author_element is not None:
                  name_element = author_element.find(f"{ATOM_NAMESPACE}name")
                  if name_element is not None and name_element.text:
                      author_name = name_element.text

              summary_text: str = ""
              if summary_element is not None and summary_element.text:
                  summary_text = strip_html_tags(summary_element.text)

              entries.append(
                  FeedEntry(
                      title=(
                          title_element.text
                          if title_element is not None and title_element.text
                          else ""
                      ),
                      link=(
                          link_element.get("href", "")
                          if link_element is not None
                          else ""
                      ),
                      updated=(
                          updated_element.text
                          if updated_element is not None and updated_element.text
                          else ""
                      ),
                      author=author_name,
                      summary=summary_text,
                  )
              )

          return entries


      def draw_list_view(
          stdscr: "curses.window",
          entries: list[FeedEntry],
          selected_index: int,
          scroll_offset: int,
          max_height: int,
          max_width: int,
          active_feed: str = "activity",
      ) -> None:
          """Draw the main list view of feed entries."""
          header: str = f" GitLab Feed [{active_feed}] "
          stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
          stdscr.addnstr(0, 0, header.center(max_width), max_width - 1)
          stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)

          stdscr.attron(curses.color_pair(3) | curses.A_BOLD)
          column_header: str = f"  {'Date':<18}{'Author':<20}{'Title'}"
          stdscr.addnstr(1, 0, column_header.ljust(max_width), max_width - 1)
          stdscr.attroff(curses.color_pair(3) | curses.A_BOLD)

          visible_entry_count: int = max_height - 4
          for display_row in range(visible_entry_count):
              entry_index: int = display_row + scroll_offset
              if entry_index >= len(entries):
                  break

              entry = entries[entry_index]
              is_selected: bool = entry_index == selected_index
              screen_row: int = display_row + 2

              date_str: str = entry.display_date
              author_str: str = entry.author[:18]
              title_str: str = entry.title

              line: str = f"  {date_str:<18}{author_str:<20}{title_str}"
              line = line[:max_width - 1]

              if is_selected:
                  stdscr.attron(curses.color_pair(2) | curses.A_BOLD)
                  stdscr.addnstr(
                      screen_row, 0, line.ljust(max_width - 1), max_width - 1
                  )
                  stdscr.attroff(curses.color_pair(2) | curses.A_BOLD)
              else:
                  stdscr.addnstr(screen_row, 0, line, max_width - 1)

          entry_count_indicator: str = (
              f" {selected_index + 1}/{len(entries)} "
          )
          footer: str = (
              " [j/k] Navigate  [Enter/o] Open  "
              "[d] Detail  [Tab] Switch feed  [r] Refresh  [q] Quit "
              + entry_count_indicator
          )
          stdscr.attron(curses.color_pair(1))
          stdscr.addnstr(
              max_height - 1, 0, footer.center(max_width), max_width - 1
          )
          stdscr.attroff(curses.color_pair(1))


      def draw_detail_view(
          stdscr: "curses.window",
          entry: FeedEntry,
          detail_scroll: int,
          max_height: int,
          max_width: int,
      ) -> None:
          """Draw the detail view for a single feed entry."""
          header: str = " Entry Detail "
          stdscr.attron(curses.color_pair(1) | curses.A_BOLD)
          stdscr.addnstr(0, 0, header.center(max_width), max_width - 1)
          stdscr.attroff(curses.color_pair(1) | curses.A_BOLD)

          content_width: int = max_width - 4
          detail_lines: list[str] = []

          detail_lines.append(f"Title:   {entry.title}")
          detail_lines.append(f"Author:  {entry.author}")
          detail_lines.append(f"Date:    {entry.display_date}")
          detail_lines.append(f"Link:    {entry.link}")
          detail_lines.append("")
          detail_lines.append("--- Summary ---")

          if entry.summary:
              wrapped_summary_lines: list[str] = textwrap.wrap(
                  entry.summary, width=content_width
              )
              detail_lines.extend(wrapped_summary_lines)
          else:
              detail_lines.append("(no summary available)")

          visible_line_count: int = max_height - 3
          for display_row, line_index in enumerate(
              range(
                  detail_scroll,
                  min(detail_scroll + visible_line_count, len(detail_lines)),
              )
          ):
              screen_row: int = display_row + 2
              line = detail_lines[line_index]

              if line.startswith("Title:") or line.startswith("--- "):
                  stdscr.attron(curses.A_BOLD)
                  stdscr.addnstr(screen_row, 2, line[:content_width], content_width)
                  stdscr.attroff(curses.A_BOLD)
              elif line.startswith("Link:"):
                  stdscr.attron(curses.color_pair(4))
                  stdscr.addnstr(screen_row, 2, line[:content_width], content_width)
                  stdscr.attroff(curses.color_pair(4))
              else:
                  stdscr.addnstr(screen_row, 2, line[:content_width], content_width)

          footer: str = (
              " [j/k] Scroll  [Enter/o] Open  [Esc/Backspace] Back  [q] Quit "
          )
          stdscr.attron(curses.color_pair(1))
          stdscr.addnstr(
              max_height - 1, 0, footer.center(max_width), max_width - 1
          )
          stdscr.attroff(curses.color_pair(1))


      def open_in_browser(url: str) -> None:
          """Open a URL in the default browser."""
          if not url:
              return
          try:
              subprocess.Popen(
                  ["open", url],
                  stdout=subprocess.DEVNULL,
                  stderr=subprocess.DEVNULL,
              )
          except FileNotFoundError:
              webbrowser.open(url)


      def main_tui(stdscr: "curses.window") -> None:
          """Main TUI loop managing navigation and rendering."""
          curses.curs_set(0)
          curses.use_default_colors()

          curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_CYAN)
          curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_WHITE)
          curses.init_pair(3, curses.COLOR_CYAN, -1)
          curses.init_pair(4, curses.COLOR_BLUE, -1)

          stdscr.clear()
          max_height, max_width = stdscr.getmaxyx()
          stdscr.addstr(max_height // 2, max_width // 2 - 10, "Fetching feed...")
          stdscr.refresh()

          active_feed: str = "activity"
          feed_names: list[str] = list(FEED_SOURCES.keys())

          entries: list[FeedEntry] = fetch_feed(active_feed)
          if not entries:
              stdscr.clear()
              stdscr.addstr(
                  max_height // 2, max_width // 2 - 12, "No entries found. Press q."
              )
              stdscr.refresh()
              while stdscr.getch() != ord("q"):
                  pass
              return

          selected_index: int = 0
          scroll_offset: int = 0
          viewing_detail: bool = False
          detail_scroll: int = 0

          while True:
              stdscr.clear()
              max_height, max_width = stdscr.getmaxyx()

              if viewing_detail:
                  draw_detail_view(
                      stdscr,
                      entries[selected_index],
                      detail_scroll,
                      max_height,
                      max_width,
                  )
              else:
                  draw_list_view(
                      stdscr,
                      entries,
                      selected_index,
                      scroll_offset,
                      max_height,
                      max_width,
                      active_feed,
                  )

              stdscr.refresh()
              key_code: int = stdscr.getch()
              visible_entry_count: int = max_height - 4

              if key_code == ord("q"):
                  break

              if viewing_detail:
                  if key_code in (27, curses.KEY_BACKSPACE, 127, curses.KEY_LEFT):
                      viewing_detail = False
                      detail_scroll = 0
                  elif key_code in (ord("j"), curses.KEY_DOWN):
                      detail_scroll += 1
                  elif key_code in (ord("k"), curses.KEY_UP):
                      detail_scroll = max(0, detail_scroll - 1)
                  elif key_code in (
                      ord("o"), ord("\n"), curses.KEY_ENTER, 10, 13,
                  ):
                      open_in_browser(entries[selected_index].link)
              else:
                  if key_code in (ord("j"), curses.KEY_DOWN):
                      if selected_index < len(entries) - 1:
                          selected_index += 1
                          if selected_index >= scroll_offset + visible_entry_count:
                              scroll_offset = (
                                  selected_index - visible_entry_count + 1
                              )
                  elif key_code in (ord("k"), curses.KEY_UP):
                      if selected_index > 0:
                          selected_index -= 1
                          if selected_index < scroll_offset:
                              scroll_offset = selected_index
                  elif key_code in (
                      ord("o"), ord("\n"), curses.KEY_ENTER, 10, 13,
                  ):
                      open_in_browser(entries[selected_index].link)
                  elif key_code == ord("d"):
                      viewing_detail = True
                      detail_scroll = 0
                  elif key_code == ord("\t"):
                      current_index = feed_names.index(active_feed)
                      active_feed = feed_names[
                          (current_index + 1) % len(feed_names)
                      ]
                      stdscr.clear()
                      stdscr.addstr(
                          max_height // 2,
                          max_width // 2 - 10,
                          f"Loading {active_feed}...",
                      )
                      stdscr.refresh()
                      entries = fetch_feed(active_feed)
                      selected_index = 0
                      scroll_offset = 0
                  elif key_code == ord("r"):
                      stdscr.clear()
                      stdscr.addstr(
                          max_height // 2, max_width // 2 - 10, "Refreshing..."
                      )
                      stdscr.refresh()
                      entries = fetch_feed(active_feed)
                      selected_index = 0
                      scroll_offset = 0
                  elif key_code == ord("g"):
                      selected_index = 0
                      scroll_offset = 0
                  elif key_code == ord("G"):
                      selected_index = len(entries) - 1
                      scroll_offset = max(
                          0, len(entries) - visible_entry_count
                      )


      def main() -> None:
          """Entry point for the GitLab feed TUI."""
          try:
              curses.wrapper(main_tui)
          except KeyboardInterrupt:
              pass


      if __name__ == "__main__":
          main()
    '';
  };
}
