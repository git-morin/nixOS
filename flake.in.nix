{
  inputs = let
    dep = url: { inherit url; inputs.nixpkgs.follows = "nixpkgs"; };
  in {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = (dep "github:nix-community/home-manager");
    nixvim = (dep "github:nix-community/nixvim");
    minegrub-theme = (dep "github:Lxtharia/minegrub-theme");
    nixos-wsl = (dep "github:nix-community/NixOS-WSL");
    proxmox-nixos = (dep "github:SaumonNet/proxmox-nixos");
    disko = (dep "github:nix-community/disko");
    nixos-anywhere = (dep "github:nix-community/nixos-anywhere");
  };

  outputs = {
    nixpkgs,
    flake-parts,
    home-manager,
    nixvim,
    minegrub-theme,
    nixos-wsl,
    proxmox-nixos,
    disko,
    nixos-anywhere,
    ...
  }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [ ./flakes ];
    };
}