{ inputs, ... }:
{
  imports = [
    inputs.emanote.flakeModule
  ];

  perSystem = {
    emanote.sites = {
      notebook = {
        layers = [
          { path = ../notebook; pathString = "./notebook"; }
          { path = ../homes; pathString = "./homes"; mountPoint = "programming/nix/homes"; }
          { path = ../hosts; pathString = "./hosts"; mountPoint = "programming/nix/hosts"; }
          { path = ../lib; pathString = "./lib"; mountPoint = "programming/nix/lib"; }
          { path = ../flakes; pathString = "./flakes"; mountPoint = "programming/nix/flakes"; }
        ];
        extraConfig = {
          template = {
            baseUrl = "/nixOS/";
          };
        };
      };
    };
  };
}
