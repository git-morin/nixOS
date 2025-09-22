{ inputs, system, userList }:
{ config, pkgs, ... }:
let
  lib = (import ../lib { inherit inputs; }).withInputs inputs;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs lib; };
    users = {
      gab = { config, pkgs, ... }: {
        imports = [
          ../homes/common
        ] ++ (map (name: ../homes/${name}) userList);
        _module.args = {
          inherit inputs system;
        };
      };
    };
  };
}