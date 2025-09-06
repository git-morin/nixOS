<div align='center'>
<img src="assets/logo.png" />
</div>

<div align='center'>

# ❄️ NixOS Configuration
[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)
---

## 🏗️ Overview

```mermaid
---
config:
  layout: elk
---
flowchart TB
    A["🏠 homes/"] --> C["🖼️ graphical"] & D["📟 terminal"] & Z["🤝 common"]
    Z --> C & D
    C --> G["👑 main/"]
    D --> G & I["🛢️ server/"] & H["📦 wsl/"]
    style C fill:#00C853
    style D fill:#2962FF
    style Z fill:#FFF9C4
```

</div>

<div align='center'>

## 📂 Project Structure

</div>

```
┌── 🏠 homes/           # HomeManager configurations for my user. (gab)
│   ├── 🤝 common/        # Configurations shared across all my environments.
│   ├── 🖼️ graphical/     # Configurations for my user with a graphical environment (GUI)
│   └── 📟 terminal/      # Configurations for my user with a terminal environment (TUI)
├── 🖥️ hosts/           # NixOS configurations for my machines.
│   ├── 🤝 common/        # Configurations shared across all my hosts.
│   ├── 👑 main/          # Configuration for my main computer.
│   ├── 🛢️ server/        # Configuration for my homelab server.
│   └── 📦 wsl/           # Configuration for my WSL environment.
├── 💿 iso/             # ISO installer configurations.
├── 📚 lib/             # Library of helper Nix functions.
└── 📜 README.md        # You are here.
```

---