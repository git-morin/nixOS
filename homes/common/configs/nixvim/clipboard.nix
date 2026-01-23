{ pkgs, ... }:
{
  clipboard = {
    register = "unnamedplus";
    providers = pkgs.lib.mkIf (!pkgs.stdenv.isDarwin) {
      wl-copy.enable = true;
      xsel.enable = true;
    };
  };
}
