{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Editors
    neovim
    helix

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

    # Development - Languages & Runtimes
    go
    rustup
    gleam
    erlang

    # Development - Node.js
    fnm
    pnpm

    # Development - Python
    pyenv
    pipx
    uv

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
    chezmoi
    tldr
    imagemagick
    vault
    ansible
    yamllint
  ];
}
