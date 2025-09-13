{ inputs, ... }:
{
  emanote.sites = {
    docs = {
      layers = [
        { path = ./docs; pathString = "./docs"; }
      ];
    };
  };
}
