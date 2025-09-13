{ inputs, ... }:
{
  imports = [
    inputs.emanote.flakeModule
  ];

  perSystem = {
    emanote.sites = {
      wiki = {
        layers = [
          { path = ./wiki; pathString = "./wiki"; }
        ];
      };
    };
  };
}
