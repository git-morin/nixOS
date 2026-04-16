{ pkgs, ... }: {
  programs.bash.shellAliases = {
    whoami = "coreutils --coreutils-prog=whoami";
  };

  programs.zsh.shellAliases = {
    whoami = "coreutils --coreutils-prog=whoami";
  };

  programs.zsh.initExtra = ''
    eval "$(jenv init -)"

    # Auto-register JDKs with jenv
    for jdk in /Library/Java/JavaVirtualMachines/*/Contents/Home; do
      if [ -d "$jdk" ] && ! jenv versions 2>/dev/null | grep -q "$(basename "$(dirname "$(dirname "$jdk")")")"; then
        jenv add "$jdk" >/dev/null 2>&1
      fi
    done
  '';
}
