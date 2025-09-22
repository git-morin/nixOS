{ inputs, system, userList }:
{ config, pkgs, ... }:
let
  _innerLib = import ../lib;
  innerLib = _innerLib.withInputs inputs;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs system;
      innerLib = innerLib;
    };
    users = {
      gab = { config, pkgs, ... }: {
        imports = [
          ../homes/common
        ] ++ (map (name: ../homes/${name}) userList);
        _module.args = {
          inherit inputs system;
          innerLib = innerLib;
        };
      };
    };
  };
}