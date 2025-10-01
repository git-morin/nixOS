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
    
    # KDE Plasma 6 with Wayland
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
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
      xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };
}
