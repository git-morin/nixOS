# Hosts

This directory contains NixOS/nix-darwin configurations for all my machines.

## Overview

| Host | Platform | Purpose |
|------|----------|---------|
| [[main]]# | NixOS (x86_64-linux) | Desktop workstation with NVIDIA GPU |
| [[server]]# | NixOS (x86_64-linux) | Proxmox homelab server |
| [[wsl]]# | NixOS-WSL | Windows Subsystem for Linux |
| [[macos]]# | nix-darwin (aarch64-darwin) | MacBook for work |

## Structure

Each host directory contains:

- `default.nix` - Entry point that imports all modules
- `_meta.nix` - Host metadata (hostname, system type)
- Various module files for specific configurations

## Common Configuration

The [[common]]# directory contains shared configuration that all NixOS hosts inherit:

![[common/default.nix]]