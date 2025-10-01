{pkgs, inputs, ...}:{
  programs = {
    # KDE Partition Manager
    partition-manager.enable = true;
  };

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    xserver.videoDrivers = ["nvidia"];
    
    # KDE Plasma 6 - Start with X11 for better NVIDIA compatibility
    displayManager.sddm = {
      enable = true;
      # Disable Wayland for now due to NVIDIA
      wayland.enable = false;
    };
    
    # Set default session to X11
    displayManager.defaultSession = "plasma";
    
    desktopManager.plasma6.enable = true;
    
    printing.enable = false;
    pulseaudio.enable = false;
    geoclue2.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # XDG Portal configuration for KDE
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };
  
  # Environment variables for NVIDIA with KDE
  environment.sessionVariables = {
    # NVIDIA
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Disable hardware cursor for NVIDIA (can cause black screen)
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
