{pkgs, inputs, ...}:{
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock = {
      enable = true;
    };
    uwsm = {
      enable = true;
    };
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
    displayManager.sddm.enable = true;
    displayManager.sessionPackages = [ pkgs.hyprland ];
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
    hypridle = {
      enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}