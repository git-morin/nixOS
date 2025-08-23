{ inputs, system, userList }:
{ config, pkgs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
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
