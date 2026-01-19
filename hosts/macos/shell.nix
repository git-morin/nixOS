{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableSyntaxHighlighting = true;
    shellInit = ''
      export EDITOR='nvim'
      export LANG=en_US.UTF-8
    '';
    interactiveShellInit = ''
      # fnm (Node version manager)
      eval "$(fnm env --use-on-cd --shell zsh)"

      # direnv
      eval "$(direnv hook zsh)"

      # pyenv
      export PYENV_ROOT="$HOME/.pyenv"
      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

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

      # Aliases
      alias rebuild='nh darwin switch ~/.config/nix-darwin'
      alias rebuild-build='nh darwin build ~/.config/nix-darwin'
      alias rebuild-test='nh darwin test ~/.config/nix-darwin'

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
    '';
  };

  environment.variables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
  };
}
