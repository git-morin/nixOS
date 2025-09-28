# NixOS

I use NixOS to set up my *nix environments.

I currently have three machines which run nixos derivations:

- [[main]]# My main personal machine
- [[server]]# My homelab server machine
- [[wsl]]# My nixOS set up for a WSL machine (I dual-boot windows)

There is also:
- [[common]] # My nixOS derivation that is added to each host derivation

You can find most of my nixOS code in this notebook.
I've added comments to places I felt we're adequate

- [[lib]]# My nix functions re-used in my derivations
- [[homes]]# My home-manager configurations for my various hosts
- [[flakes]]# My flake-parts derivations