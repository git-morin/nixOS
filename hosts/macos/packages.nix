{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Terminal & Shell
    zellij
    bash
    bash-completion

    # Version Control
    git
    lazygit
    glab # gitlab
    difftastic

    # Search & Navigation
    ripgrep
    fd
    fzf
    tree
    eza # ls
    zoxide # cd

    # File Processing
    jq
    yq
    bat # cat
    gdu
    pv

    # System Monitoring
    htop
    bottom
    watch
    procs # ps
    dust # du
    duf # df

    # Network Tools
    curl
    wget
    aria2
    croc
    nmap
    inetutils
    mtr

    # Kubernetes & Containers
    kubectl
    kubectx
    k9s
    minikube

    # Development - Elixir
    beamMinimal28Packages.elixir_1_20

    # Development - Rust
    rustup

    # Development - Node.js
    fnm
    pnpm

    # Development - Python
    pipx
    uv
    micromamba
    
    # Development - Java/Build
    maven
    go-task

    # Development - Other Tools
    direnv
    mise

    # Database Tools
    lazysql

    # Utilities
    coreutils
    findutils
    gnused
    gnutar
    gnugrep
    gzip
    zstd
    lz4
    xz
    unzip
    p7zip

    # Nix Tools
    nh

    # Misc CLI
    vault
    ansible
    yamllint
  ];
}
