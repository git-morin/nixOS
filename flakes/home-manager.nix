{ inputs, system, userList }:
{ config, pkgs, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = builtins.listToAttrs (map (name: {
      inherit name;
      value = { config, pkgs, ... }: {
        imports = [
          ../homes/common
          ../homes/${name}
        ];
        _module.args = {
          inherit inputs system;
        };
      };
    }) userList);
  };
}
