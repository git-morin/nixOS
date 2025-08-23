<div align='center'>
<img src="assets/logo.png" />
</div>
<div align='center'>
NixOS
</div>
<div align='center'>
📂 Project Structure
</div>

```
├── ❄️ flake.nix   # Main entry-point for the Nix flake setup.
├── 🍧 flakes/     # Flake-related configuration.
├── 🏠 homes/      # Home Manager configurations.
│   ├── 📂 common/          # Common configurations across all homes.
│   ├── 📂 gab-graphical/   # Configuration for main user (graphical)
│   └── 📂 gab-terminal/    # Configuration for terminal user (WSL/Proxmox)
├── 🏠 hosts/      # System-wide configurations for different hosts.
│   ├── 📂 common/        # Common configurations across all hosts.
│   ├── 📂 main/          # Configuration for my 'main' host. (graphical)
│   ├── 📂 wsl/           # Configuration for my WSL hosts. (virtualized)
│   └── 📂 proxmox/       # Configuration for my Proxmox VE host. (server)
├── 💿 iso/        # ISO installer configurations for each host.
├── 📚 lib/        # Library of helper Nix functions.
└── 📜 README.md # You are here.
```

<br />

