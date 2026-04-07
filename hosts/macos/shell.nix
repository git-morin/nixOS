{ lib, config, ... }:
let
  commonAliases = import ../../lib/aliases.nix;
  aliasLines = lib.concatStringsSep "\n"
    (lib.mapAttrsToList (name: cmd: "alias ${name}='${cmd}'") commonAliases);
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    shellInit = ''
      export EDITOR='nvim'
      export LANG=en_US.UTF-8
      export MANPATH="/usr/local/man:$MANPATH"
      export ARCHFLAGS="-arch $(uname -m)"
      export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

      # Source secrets from outside the repo
      [[ -f "$HOME/.config/secrets/env.sh" ]] && source "$HOME/.config/secrets/env.sh"
    '';
    interactiveShellInit = ''
      # fnm (Node version manager)
      eval "$(fnm env --use-on-cd --shell zsh)"

      # direnv
      eval "$(direnv hook zsh)"

      # SDKMAN
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

      # Cargo/Rust
      [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

      # pnpm
      export PNPM_HOME="$HOME/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac

      # Nimble
      export PATH="$HOME/.nimble/bin:$PATH"

      # RVM
      export PATH="$PATH:$HOME/.rvm/bin"

      # Bun
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
      [[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

      # Common aliases (from lib/aliases.nix)
      ${aliasLines}

      # macOS-specific aliases
      alias rebuild='nh darwin switch ~/.config/nix-darwin'
      alias rebuild-build='nh darwin build ~/.config/nix-darwin'
      alias rebuild-test='nh darwin test ~/.config/nix-darwin'
      alias notebook='nix run ~/.config/nix-darwin#notebook'
      alias gc='nix-collect-garbage -d'
      alias good-morning='$GAB_CLAUDE/plugins/gab/commands/good-morning.sh'

      # zoxide (smarter cd)
      eval "$(zoxide init zsh)"
      alias cd='z'
      alias cdi='zi'

      # Zellij completions
      autoload -U +X compinit && compinit . <( zellij setup --generate-completion zsh | sed -Ee 's/^(_(zellij) ).*/compdef \1\2/' )

      # Micromamba
      export MAMBA_EXE='/opt/homebrew/bin/micromamba'
      export MAMBA_ROOT_PREFIX="$HOME/micromamba"
      if [[ -x "$MAMBA_EXE" ]]; then
        __mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
        if [ $? -eq 0 ]; then
          eval "$__mamba_setup"
        else
          alias micromamba="$MAMBA_EXE"
        fi
        unset __mamba_setup
      fi

      # Zellij auto-start (only in Ghostty/WezTerm, not in IDEs or nested sessions)
      if [[ -z "$ZELLIJ" && -z "$VSCODE_INJECTION" && -z "$TERMINAL_EMULATOR" ]]; then
        case "$TERM_PROGRAM" in
          ghostty|WezTerm)
            zellij -l welcome
            ;;
        esac
      fi
    '';
  };

  environment.variables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
    GAB_CLAUDE = "$HOME/claude";
    B2B_IDENTITY_CLAUDE = "$HOME/b2b-identity/devops/claude";

    # ZScaler SSL CA bundle (fixes SSL interception errors)
    SSL_CERT_FILE = "$HOME/.certs/ca-bundle.pem";
    REQUESTS_CA_BUNDLE = "$HOME/.certs/ca-bundle.pem";
    AWS_CA_BUNDLE = "$HOME/.certs/ca-bundle.pem";
    CURL_CA_BUNDLE = "$HOME/.certs/ca-bundle.pem";
    HTTPLIB2_CA_CERTS = "$HOME/.certs/ca-bundle.pem";
    NODE_EXTRA_CA_CERTS = "$HOME/.certs/ca-bundle.pem";
  };

  system.activationScripts.postActivation.text = ''
    CERT_DIR="$HOME/.certs"
    CERT_FILE="$CERT_DIR/ca-bundle.pem"
    if [ ! -f "$CERT_FILE" ]; then
      echo "Downloading ZScaler CA bundle..."
      mkdir -p "$CERT_DIR"
      /usr/bin/curl --insecure -o "$CERT_FILE" \
        "$(cat ${config.sops.secrets.zscaler_ca_url.path})" \
        && echo "ZScaler CA bundle downloaded to $CERT_FILE" \
        || echo "WARNING: Failed to download ZScaler CA bundle. Ensure you are on VPN."
    fi
  '';
}
