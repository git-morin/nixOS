{ inputs, ... }:
{
  imports = [
    inputs.emanote.flakeModule
  ];

  emanote.sites = {
    docs = {
      layers = [
        { path = ./docs; pathString = "./docs"; }
      ];
    };
  };
}
