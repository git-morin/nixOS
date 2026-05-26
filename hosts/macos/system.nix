{ pkgs, lib, config, ... }:
{
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      orientation = "left";
      wvous-br-corner = 14; # quick note
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv"; # list view
      _FXShowPosixPathInTitle = true;
      _FXSortFoldersFirst = true;
      AppleShowAllFiles = true;
      QuitMenuItem = true;
      NewWindowTarget = "Other";
      NewWindowTargetPath = "file:///Users/gabriel.morin/";
    };

    # Screenshots
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
      disable-shadow = true;
    };

    # Login
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    # Menu bar clock
    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 0; # when space allows
      ShowDayOfWeek = true;
    };

    # Global settings
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };

    # Show hidden files in NSOpenPanel/NSSavePanel (IDE open dialogs, etc.)
    CustomUserPreferences = {
      "NSGlobalDomain" = {
        AppleShowAllFiles = true;
      };
    };
  };
  
  fonts.packages = with pkgs.nerd-fonts; [
    hack
    jetbrains-mono
  ];

  security.pam.services.sudo_local.touchIdAuth = true;
  system.primaryUser = "gabriel.morin";
  networking.hostName = "LNEGQ7JJR7FWG";
  networking.computerName = "LNEGQ7JJR7FWG";
  system.stateVersion = 6;

  # Skip the userDefaults activation step (~20-25s of `launchctl asuser sudo`
  # PAM overhead per switch) when system.defaults hasn't changed. Fingerprint
  # is the store path of a derivation containing the serialized config; a
  # marker file at /var/lib/nix-darwin/userDefaults.fingerprint records the
  # last applied path. When they match, the block is skipped.
  system.activationScripts.userDefaults.text = lib.mkMerge [
    (lib.mkBefore ''
      __userDefaultsFingerprint=${pkgs.writeText "user-defaults.json"
        (builtins.toJSON {
          inherit (config.system.defaults)
            dock finder screencapture loginwindow menuExtraClock
            NSGlobalDomain trackpad CustomUserPreferences;
        })}
      __userDefaultsMarker=/var/lib/nix-darwin/userDefaults.fingerprint
      if [ "$(readlink "$__userDefaultsMarker" 2>/dev/null)" = "$__userDefaultsFingerprint" ]; then
        echo >&2 "user defaults: unchanged, skipping"
      else
    '')
    (lib.mkAfter ''
        mkdir -p "$(dirname "$__userDefaultsMarker")"
        ln -sfn "$__userDefaultsFingerprint" "$__userDefaultsMarker"
      fi
    '')
  ];
}
