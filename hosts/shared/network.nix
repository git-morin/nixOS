{
  networking.networkmanager.enable = true;
  networking.firewall = {
    # SSH
    allowedTCPPorts = [ 22 ];
    allowedUDPPorts = [ 22 ];
  };
}
