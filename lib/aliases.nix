# Common shell aliases shared across zsh and nushell.
# Imported by hosts/macos/shell.nix and homes/common/configs/nushell.nix.
{
  # eza -> ls
  ls = "eza --icons --group-directories-first";
  ll = "eza -la --icons --group-directories-first --git";
  la = "eza -a --icons --group-directories-first";
  lt = "eza --tree --icons --level=2";
  lta = "eza --tree --icons -a --level=2";

  # bat -> cat
  cat = "bat --paging=never";
  catp = "bat";

  # ripgrep -> grep
  grep = "rg";

  # bottom -> top/htop
  top = "btm";
  htop = "btm";

  # gdu -> du
  du = "gdu";

  # difftastic -> diff
  diff = "difft";

  # procs -> ps
  ps = "procs";
  psa = "procs -a";

  # dust (tree view)
  dut = "dust";

  # duf -> df
  df = "duf";

  # Nix store maintenance
  clean = "home-manager expire-generations '-1 days' && sudo nix-collect-garbage -d";
  optimize = "nix-store --optimize";
}
