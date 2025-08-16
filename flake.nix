# Do not modify! This file is generated.

{
  inputs = {
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    flakegen.url = "github:jorsn/flakegen";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    minegrub-theme = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Lxtharia/minegrub-theme";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
    nixos-wsl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NixOS-WSL";
    };
    proxmox-nixos = {
      url = "github:SaumonNet/proxmox-nixos";
    };
  };
  outputs = inputs: inputs.flakegen ./flake.in.nix inputs;
}