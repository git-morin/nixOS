let
  lib = import ../../lib;
in
{
  imports = lib.importNixFiles ./. ++ [ 
    ../common
  ];
}
