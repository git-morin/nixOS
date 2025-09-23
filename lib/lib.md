# lib

This is my nix `lib` code.

It is functions I use throughout this codebase to reduce boilerplate.

- `importNixFiles` : Read all .nix files (except default.nix and _meta.nix) and import them.
  - I use this in `default.nix` files to avoid having to write each .nix file in the imports
- `importPackagesFromPath`: Basicly `importNixFiles` but it is for home-manager packages.
  - I use this in `default.nix` files of my ![[homes]] to avoid having to write each .nix file in the packages
- `importConfigsFromPath`: Basicly `importNixFiles` but it is for home-manager configs.
  - I use this in `default.nix` files of my ![[homes]] to avoid having to write each .nix file in the configs
- `buildNixosConfiguration`: Used to generate the main nixos/flake-parts system declaration
  - Used only in the `flakes/nixos.nix` file.

![[lib.nix]]