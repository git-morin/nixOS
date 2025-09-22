{ inputs, ... }:
{
  imports = [
    inputs.emanote.flakeModule
  ];

  perSystem = {
    emanote.sites = {
      notebook = {
        layers = [
          { path = ../notebook; pathString = "../notebook"; }
          { path = ../homes; pathString = "../homes"; }
          { path = ../hosts; pathString = "../hosts"; }
          { path = ../lib; pathString = "../lib"; }
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
