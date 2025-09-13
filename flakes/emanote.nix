{ inputs, ... }:
{
  imports = [
    inputs.emanote.flakeModule
  ];

  perSystem = {
    emanote.sites = {
      docs = {
        layers = [
          { path = ./docs; pathString = "./docs"; }
        ];
      };
    };
  };
}
