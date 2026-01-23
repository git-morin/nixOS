{ inputs, system, userList, primaryUser ? "gab" }:
{ config, pkgs, ... }:
let
  _innerLib = import ../lib;
  innerLib = _innerLib.withInputs inputs;
  isDarwin = builtins.match ".*-darwin" system != null;
  homePrefix = if isDarwin then "/Users" else "/home";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bck";
    extraSpecialArgs = {
      inherit inputs system;
      innerLib = innerLib;
    };
    users.${primaryUser} = { config, pkgs, lib, ... }: {
      home.username = primaryUser;
      home.homeDirectory = lib.mkForce "${homePrefix}/${primaryUser}";
      fonts.fontconfig.enable = lib.mkForce false;
      disabledModules = [
        "targets/darwin/fonts.nix"
        "targets/darwin/linkapps.nix"
      ];
      imports = [
        ../homes/common
      ] ++ (map (name: ../homes/${name}) userList);
      _module.args = {
        inherit inputs system;
        innerLib = innerLib;
      };
    };
  };
}
