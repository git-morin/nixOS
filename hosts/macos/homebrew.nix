{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
      "openfga/tap"
      "databricks/tap"
    ];

    brews = [
      "databricks/tap/databricks"
      "pulumi"
      "openfga/tap/fga"
      "kafka"
      "ttyd"
    ];

    # GUI Applications (casks)
    casks = [
      # Terminals
      "ghostty"
      "iterm2"
      "wezterm"

      # Editors & IDEs
      "visual-studio-code"
      "jetbrains-toolbox"

      # Browsers & Communication
      "discord"
      "spotify"

      # Development Tools
      "docker-desktop"
      "dbeaver-community"
      "claude-code"
      "burp-suite"
      "meld"

      # System Utilities
      "amethyst"
      "scroll-reverser"
      "stats"

      # Media
      "gimp"
      "blackhole-2ch"

      # Kubernetes
      "freelens"

      # Fonts
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
    ];
  };
}
