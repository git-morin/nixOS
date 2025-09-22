# NixOS


To rebuild NixOS:

```
nixos-rebuild <switch|test|build> --flake <path>#<flake-name>
```

Ideally I should do this from the folder that contains all my nix code, so that the path that I pass is `.`

In example: I can do `.#main` to build my `main` nixOS declaration 