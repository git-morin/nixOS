{ pkgs, ... }:
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
}
