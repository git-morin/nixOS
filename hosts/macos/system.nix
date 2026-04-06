{ ... }:
{
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    # Global settings
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    # Trackpad
    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
    };
  };
  
  security.pam.services.sudo_local.touchIdAuth = true;
  system.primaryUser = "gabriel.morin";
  networking.hostName = "LNEGQ7JJR7FWG";
  networking.computerName = "LNEGQ7JJR7FWG";
  system.stateVersion = 6;
}
