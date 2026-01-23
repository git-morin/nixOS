{ inputs, ... }:
let
  lib = import ../../../lib;
  wrapForUseAsNixvimConfig =
    path:
      { programs.nixvim = import path; };
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ] ++ map wrapForUseAsNixvimConfig (lib.importNixFiles ./nixvim);
}