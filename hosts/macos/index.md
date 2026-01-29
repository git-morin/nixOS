# macOS

This is my nix-darwin configuration for macOS (Apple Silicon).

## Purpose

This configuration manages my work MacBook, providing a declarative way to configure macOS system settings and install applications via Homebrew.

## System Defaults

macOS-specific settings for a better developer experience:

![[macos/system.nix]]

## Homebrew

Since many macOS applications aren't available in nixpkgs, Homebrew is used for GUI apps:

![[macos/homebrew.nix]]

## Differences from NixOS

Unlike the NixOS hosts, macOS uses:
- `nix-darwin` instead of NixOS modules
- Homebrew for GUI applications (casks)
- Different system defaults API
