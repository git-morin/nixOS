{ lib, ... }:
let
  customConfigPath = ./_homebrew-tm.nix;
  hasCustomConfig = builtins.pathExists customConfigPath;
  customConfig = if hasCustomConfig then (import customConfigPath { inherit lib; }) else { homebrew = {}; };
in
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
      "LizardByte/homebrew"
    ] ++ (customConfig.homebrew.taps or []);

    brews = [
      "lz4"
      "xz"
      "awscli"
      "databricks/tap/databricks"
      "pulumi"
      "openfga/tap/fga"
      "kafka"
      "ttyd"
      "LizardByte/homebrew/sunshine"
    ] ++ (customConfig.homebrew.brews or []);

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
      "hoppscotch"

      # System Utilities
      "amethyst"
      "scroll-reverser"
      "stats"

      # Media
      #"gimp"
      "blackhole-2ch"

      # Kubernetes
      "freelens"

      # Fonts
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
    ] ++ (customConfig.homebrew.casks or []);
  };
}
