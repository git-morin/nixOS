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
      "openfga/tap"
      "databricks/tap"
      "LizardByte/homebrew"
      "peonping/tap"
    ] ++ (customConfig.homebrew.taps or []);

    brews = [
      "awscli"
      "databricks/tap/databricks"
      "pulumi"
      "openfga/tap/fga"
      "kafka"
      "ttyd"
      "LizardByte/homebrew/sunshine"
      "PeonPing/tap/peon-ping"
      "jenv"
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
      "jdk-mission-control"
      "zulu@17"
      "zulu@21"

      # System Utilities
      "amethyst"
      "scroll-reverser"
      "stats"

      # Media
      #"gimp"
      "blackhole-2ch"

      # Kubernetes
      "freelens"
    ] ++ (customConfig.homebrew.casks or []);
  };
}
