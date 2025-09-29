# nix

[Nix](https://nixos.org/) is a tool and a functional language that takes a unique approach to package management and system configuration.

Nix also employs a clever way to store packages/derivations/data to reuse and avoid building software on demand (instead pulling from the nixpkgs registry if possible). 

## [[nixos]]# 

[NixOS](https://nixos.org/manual/nixos/stable/) is an extension of Nix, basically applying nix as the replacement for traditional tools like `apk`, `apt`, `pacman`, etc...

What `nixos` does above these tools is that it also allows granular configuration of the OS itself. This means you add packages at the same place you add/edit configs, making it super easy to reproduce your environment.

I think of `nixos` as `ansible` on steroids, that you install on the host machine rather than a remote (with which you SSH into like ansible does). You also get the benefits of the nix caching/store described above.

## Tools

- [Nil](https://github.com/oxalica/nil) - Language server for Nix
- [Alejandra](https://github.com/kamadorueda/alejandra) - Nix Code Formatter