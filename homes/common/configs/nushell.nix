{
    programs.nushell = {
        enable = true;
        configFile.source = ./nushell/config.nu;
        shellAliases = {
            flakeGen = "nu -c 'cd /etc/nixos; nix run .#genflake flake.nix; cd -'"; # rebuild flake.nix with flakegen
            switch   = "nh os switch (#$env.NIXOS_FLAKE_TARGET)";  # evaluate -> build -> switch to new generation
            test     = "nh os test (#$env.NIXOS_FLAKE_TARGET)";  # evaluate -> test
            clean    = "nh clean all";  # clean up old generations
            upgrade  = "sudo nix-env --upgrade";  # upgrade packages
            optimize = "sudo nix-store --optimize"; # optimize nix-store

            whoami   = "coreutils --coreutils-prog=whoami"; # fix 'whoami' built-in which might be missing

            notebook = "nix run /etc/nixos#notebook"; # emanote dev server with live reload
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