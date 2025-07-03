{ pkgs, ... }: {
  home.packages = with pkgs; [
    # IDE
    jetbrains.rust-rover

    # Python
    python314
    uv

    # Rust
    rustup
    gcc
  ];
}
