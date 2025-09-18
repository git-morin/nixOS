{ inputs, ... }:
let
  lib = import ../../../lib;
  wrapForUseAsNixvimConfig = 
    config:
      { programs.nixvim = config; };
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ] ++ map wrapForUseAsNixvimConfig (lib.importNixFiles ./nixvim);
}