let
  commonAliases = import ../../../lib/aliases.nix;
in
{
    programs.nushell = {
        enable = true;
        configFile.source = ./nushell/config.nu;
        shellAliases = commonAliases // {
            # NixOS-specific
            flakeGen = "nu -c 'cd /etc/nixos; nix run .#genflake flake.nix; cd -'";
            switch   = "nh os switch (#$env.NIXOS_FLAKE_TARGET)";
            test     = "nh os test (#$env.NIXOS_FLAKE_TARGET)";
            upgrade  = "sudo nix-env --upgrade";
            optimize = "sudo nix-store --optimize";
            whoami   = "coreutils --coreutils-prog=whoami";
            notebook = "nix run /etc/nixos#notebook";
        };
    };

    programs.carapace = {
        enable = true;
        enableNushellIntegration = true;
    };

    programs.starship = {
        enable = true;
        settings = {
            add_newline = true;
            character = {
                success_symbol = "[➜](bold green)";
                error_symbol = "[➜](bold red)";
            };
        };
    };
}
