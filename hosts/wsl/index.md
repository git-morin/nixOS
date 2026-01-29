# wsl

This is my NixOS configuration for Windows Subsystem for Linux (WSL).

## Why NixOS on WSL?

Using [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) gives me a consistent NixOS experience on Windows machines, with the same dotfiles and tooling as my Linux systems.

## Configuration

Key WSL-specific settings:

![[wsl/wsl.nix]]

## Usage

This configuration is primarily used on Windows machines where I need a Linux development environment but can't run a full Linux installation.
