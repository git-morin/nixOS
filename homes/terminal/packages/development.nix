{ pkgs, lib, ... }:
let
  python = rec {
    defaultVersion = pkgs.python312;
    additionalVersions = with pkgs; [
      python313
    ];
    packages = ps: with ps; [
      virtualenv
    ];
    default = defaultVersion.withPackages packages;
    additional = map
      (py: lib.lowPrio (py.withPackages packages))
      additionalVersions;
  };
in
{
  home.packages = with pkgs; [
    direnv
    nixd
    tree-sitter
    python.default
  ] ++ python.additional;
}
