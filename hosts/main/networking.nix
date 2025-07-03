{ lib, ... }:
{
  networking = {
    hostName = "main";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
        allowedTCPPorts = [
          22 # SSH
          5353 # Spotify cast port
          57621 # Spotify filesystem file share port
        ];
        allowedUDPPorts = [
          22 # SSH
          5353 # Spotify cast port
          57621 # Spotify filesystem file share port
        ];
      };
  };
}
