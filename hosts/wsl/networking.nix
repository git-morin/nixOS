{ lib, ... }:
{
  networking.hostName = "wsl";
  networking.networkmanager.enable = lib.mkForce false;
}