{ primaryUser, lib, ... }:
{
  homebrew.casks = [
    {
      name = "slack";
      greedy = true;
    }
  ];

  system.activationScripts.preActivation.text = lib.mkAfter ''
    if [ -d /Applications/Slack.app ] \
      && [ -x /opt/homebrew/bin/brew ] \
      && [ "$(/usr/bin/stat -f %u /Applications/Slack.app)" = "0" ]; then
      echo >&2 "slack: root-owned pkg install found; handing it over to Homebrew..."
      /usr/bin/pkill -x Slack 2>/dev/null || true
      if [ -d /opt/homebrew/Caskroom/slack ]; then
        /usr/bin/sudo -u ${primaryUser} /opt/homebrew/bin/brew uninstall --cask --force slack \
          >/dev/null 2>&1 || true
      fi
      /usr/sbin/pkgutil --forget com.tinyspeck.slackmacgap >/dev/null 2>&1 || true
      /bin/rm -rf /Applications/Slack.app
    fi
  '';
}
