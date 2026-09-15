{ lib, config, primaryUser, ... }:
let
  customConfigPath = ./_homebrew-tm.nix;
  hasCustomConfig = builtins.pathExists customConfigPath;
  customConfig = if hasCustomConfig then (import customConfigPath { inherit lib; }) else { homebrew = {}; };
  trustEntry = tap:
    if (tap.clone_target or null) != null then tap.clone_target
    else lib.toLower tap.name;
  trustedTaps = lib.sort (a: b: a < b) (map trustEntry config.homebrew.taps);
  trustJson = builtins.toJSON { trustedtaps = trustedTaps; };
  trustFile = "/Users/${primaryUser}/.homebrew/trust.json";
in
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
      extraFlags = [ "--verbose" ];
    };

    taps = [
      "openfga/tap"
      "databricks/tap"
      "LizardByte/homebrew"
      "peonping/tap"
      "libkrun/krun"
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
      "podman"
      "libkrun/krun/krunkit"
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
      "podman-desktop"
      "dbeaver-community"
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

  system.activationScripts.preActivation.text = lib.mkAfter ''
    echo >&2 "homebrew: writing tap trust file..."
    /usr/bin/install -d -o ${primaryUser} -m 700 "/Users/${primaryUser}/.homebrew"
    printf '%s' ${lib.escapeShellArg trustJson} > "${trustFile}"
    if [ -s "${config.sops.secrets.gitlab_host.path}" ]; then
      /usr/bin/sed -i "" "s|REDACTED_URL|$(cat "${config.sops.secrets.gitlab_host.path}")|g" "${trustFile}"
    else
      echo >&2 "homebrew: WARNING gitlab_host secret not yet provisioned; tm tap trust will use placeholder URL"
    fi
    /usr/sbin/chown ${primaryUser} "${trustFile}"
    chmod 600 "${trustFile}"
  '';
}
