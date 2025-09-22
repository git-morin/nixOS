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
        ];
        extraConfig.template.baseUrl = "/nixOS/";
        extraConfig = {
          template = {
            baseUrl = "/nixOS/";
          };
          pandoc = {
            rewriteClass = {
              "callout-note" = "bg-blue-100";
            };
          };
        };
      };
    };
  };
}
