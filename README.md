<div align='center'>
<img src="assets/logo.png" />
</div>

<div align='center'>

# ❄️ NixOS Configuration

*A declarative, reproducible system configuration powered by Nix flakes*

[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)
[![Nix Flakes](https://img.shields.io/badge/Nix-flakes-blue.svg?style=flat&logo=nixos&logoColor=white)](https://nixos.wiki/wiki/Flakes)
[![Home Manager](https://img.shields.io/badge/Home-Manager-blue.svg?style=flat&logo=nixos&logoColor=white)](https://github.com/nix-community/home-manager)

---

## 🏗️ Overview

```mermaid
---
config:
  layout: elk
---
flowchart TB
    A["🏠 homes/"] --> C["📂 graphical"] & D["📂 terminal"] & Z["📂 common"]
    Z --> C & D
    C --> G["🖥️ main/"]
    D --> G & I["🖥️ proxmox/"] & H["🖥️ wsl/"]
    style C fill:#00C853
    style D fill:#2962FF
    style Z fill:#FFD600
```

</div>

<div align='center'>

## 📂 Project Structure

</div>

```
┌── 🏠 homes/           # Home Manager configurations.
│   ├── 📂 common/        # Configurations shared across all my environments.
│   ├── 📂 graphical/     # Configurations for my user with a graphical environment (GUI)
│   └── 📂 terminal/      # Configurations for my user with a terminal environment (TUI)
├── 🏠 hosts/           # NixOS configurations for my hosts machines.
│   ├── 📂 common/        # Common configurations across all hosts.
│   ├── 📂 main/          # Configuration for my 'main' machine.
│   ├── 📂 wsl/           # Configuration for a WSL environment.
│   └── 📂 proxmox/       # Configuration for my ProxmoxVE host.
├── 💿 iso/             # ISO installer configurations.
├── 📚 lib/             # Library of helper Nix functions.
├── 🚀 remote-install/  # nixos-anywhere deployment tools.
├── 🔧 remote-deploy    # Convenience script for remote deployment.
└── 📜 README.md        # You are here.
```

---
<div align='center'>

**Built with ❄️ NixOS** • **Powered by 🚀 Nix Flakes**

</div>