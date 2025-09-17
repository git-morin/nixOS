{ inputs, ... }:
{
  imports = [
    inputs.emanote.flakeModule
  ];

  perSystem = {
    emanote.sites = {
      notebook = {
        layers = [
          { path = ./notebook; pathString = "./notebook"; }
        ];
      };
    };
  };
}
