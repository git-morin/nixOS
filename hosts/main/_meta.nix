{ inputs, ... }:
{
  system = "x86_64-linux";
  users = [ "graphical" ];
  additionalModules = [
    inputs.minegrub-theme.nixosModules.default
  ];
  buildIso = true;
}