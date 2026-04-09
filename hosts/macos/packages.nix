{ pkgs, ... }:
let
  splunk-cli = pkgs.buildGoModule {
    pname = "splunk-cli";
    version = "unstable-2026-04-09";
    src = pkgs.fetchFromGitHub {
      owner = "kitproj";
      repo = "splunk-cli";
      rev = "main";
      hash = "sha256-Ed/HG3mv4/JyNPUJNcKkf+C/MNl/QekITGDhrlysa9Y=";
    };
    vendorHash = "sha256-rSqZKBf5boxqQZgUdoq5SWEey3D1C9Dk0xTZ67tsXpc=";
    postInstall = ''
      mv $out/bin/splunk-cli $out/bin/splunk
    '';
    meta.description = "A CLI and MCP server for Splunk";
  };
in
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
    bruno
    opencode

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
    age
    sops

    # Misc CLI
    vault
    ansible
    yamllint
    go
    tldr
    benthos

    # Splunk
    splunk-cli
  ];
}
