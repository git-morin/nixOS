let
  lib = import ../../../lib;
in
{
  imports = [
    # from parent folder
    ../environment.nix
    ../i18n.nix
    ../network.nix
    ../nix.nix
    ../security.nix
    ../time.nix
    # from current folder
    ./users.nix
  ];
}
