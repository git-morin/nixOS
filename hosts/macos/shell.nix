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

      # Emanote notebook dev server
      alias notebook='nix run ~/.config/nix-darwin#notebook'

      # Nix store maintenance
      alias clean='nh clean all'                          # garbage collect old generations
      alias gc='nix-collect-garbage -d'                   # delete all old generations and gc
      alias optimize='nix-store --optimize'               # deduplicate nix store

      # eza -> ls
      alias ls='eza --icons --group-directories-first'
      alias ll='eza -la --icons --group-directories-first --git'
      alias la='eza -a --icons --group-directories-first'
      alias lt='eza --tree --icons --level=2'
      alias lta='eza --tree --icons -a --level=2'

      # bat -> cat
      alias cat='bat --paging=never'
      alias catp='bat'  # with pager

      # ripgrep -> grep (for simple cases)
      alias grep='rg'

      # bottom -> top/htop
      alias top='btm'
      alias htop='btm'

      # gdu -> du
      alias du='gdu'

      # difftastic -> diff
      alias diff='difft'

      # zoxide (smarter cd)
      eval "$(zoxide init zsh)"
      alias cd='z'
      alias cdi='zi'  # interactive selection

      # procs -> ps
      alias ps='procs'
      alias psa='procs -a'

      # dust -> du (tree view)
      alias dut='dust'

      # duf -> df
      alias df='duf'

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
  };
}
