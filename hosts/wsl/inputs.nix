{ inputs, ... }:
{
  system = "x86_64-linux";
  users = [ "terminal" ];
  additionalModules = [
    inputs.nixos-wsl.nixosModules.wsl
  ];
}