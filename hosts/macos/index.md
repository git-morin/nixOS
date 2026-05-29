# macOS

This is my nix-darwin configuration for macOS (Apple Silicon).

## Purpose

This configuration manages my work MacBook, providing a declarative way to configure macOS system settings and install applications via Homebrew.

## Hardware

- Model: MacBook Pro (Mac16,5 / MX2V3LL/A)
- Chip: Apple M4 Max (14 cores (10 performance + 4 efficiency))
- Memory: 36 GB
- Display: Built-in Liquid Retina XDR (3456 x 2234 Retina)
- macOS: 26.5 (build 25F71)

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
