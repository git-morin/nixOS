{ inputs, ... }:
{
  system = "x86_64-linux";
  users = [
    "graphical"
    "terminal"
  ];
  additionalModules = [
    inputs.minegrub-theme.nixosModules.default
  ];
}