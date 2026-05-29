{ config, lib, pkgs, ... }:
let
  cfg = config.programs.prek;
  yamlFormat = pkgs.formats.yaml { };
  effectiveProfile = cfg.profile // {
    repos = (cfg.profile.repos or [ ])
      ++ lib.optional (cfg.localHooks != [ ]) {
        repo = "local";
        hooks = cfg.localHooks;
      };
  };

  profileConfigFile = yamlFormat.generate "prek-profile.yaml" effectiveProfile;

  hooksRelDir = "git/hooks";
  hooksAbsDir = "${config.xdg.configHome}/${hooksRelDir}";

  hasProfileHooks = (effectiveProfile.repos or [ ]) != [ ];
  preCommitScript = ''
    #!${pkgs.runtimeShell}
    # Managed by nix-darwin (programs.prek). Do not edit.
    set -euo pipefail

    PREK="${cfg.package}/bin/prek"

    ${lib.optionalString hasProfileHooks ''
      # 1. Profile-level hooks (user-wide)
      "$PREK" run --config "${profileConfigFile}" --stage pre-commit || exit $?
    ''}

    # 2. Project-level hooks if repo has its own config
    if [ -f .pre-commit-config.yaml ] || [ -f .pre-commit-config.yml ] || [ -f prek.toml ]; then
      "$PREK" run --stage pre-commit || exit $?
    fi

    # 3. Chain to per-project .git/hooks/pre-commit if user installed one
    # (core.hooksPath overrides .git/hooks, so we manually invoke it).
    GIT_DIR="$(git rev-parse --git-dir 2>/dev/null || true)"
    if [ -n "$GIT_DIR" ] && [ -x "$GIT_DIR/hooks/pre-commit" ]; then
      "$GIT_DIR/hooks/pre-commit" "$@" || exit $?
    fi
  '';
in
{
  options.programs.prek = {
    enable = lib.mkEnableOption "prek (Rust pre-commit replacement)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.prek;
      description = "prek package to use.";
    };

    profile = lib.mkOption {
      type = yamlFormat.type;
      default = { repos = [ ]; };
      example = lib.literalExpression ''
        {
          repos = [
            {
              repo = "https://github.com/pre-commit/pre-commit-hooks";
              rev = "v5.0.0";
              hooks = [ { id = "trailing-whitespace"; } ];
            }
          ];
        }
      '';
      description = ''
        User-level prek config rendered to ~/.config/prek/profile.yaml.
        Schema follows .pre-commit-config.yaml, see
        https://prek.j178.dev/reference/configuration/.
        For inline shell-based hooks prefer `localHooks`.
      '';
    };

    localHooks = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        freeformType = yamlFormat.type;
        options = {
          id = lib.mkOption {
            type = lib.types.str;
            description = "Stable hook identifier.";
          };
          name = lib.mkOption {
            type = lib.types.str;
            description = "Human-friendly hook label.";
          };
          entry = lib.mkOption {
            type = lib.types.str;
            description = ''
              Command to execute. Either an inline string or a path to a script
              (use `pkgs.writeShellScript`). The hook fails the commit when this
              exits non-zero.
            '';
          };
          language = lib.mkOption {
            type = lib.types.str;
            default = "system";
            description = "Hook runtime. `system` runs `entry` directly.";
          };
          types = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            example = [ "text" ];
            description = "File-type filter. Empty = all files.";
          };
          stages = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "pre-commit" ];
            description = "Stages this hook runs at.";
          };
          pass_filenames = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Append matched filenames to entry.";
          };
        };
      });
      default = [ ];
      example = lib.literalExpression ''
        [
          {
            id = "no-todo";
            name = "Block TODO comments";
            entry = "''${pkgs.gnugrep}/bin/grep -nE '\\b(TODO|FIXME)\\b'";
            language = "system";
            types = [ "text" ];
          }
        ]
      '';
      description = ''
        Inline `repo: local` hooks. Each entry becomes a hook under a synthetic
        local repo in the profile config. Use this for ad-hoc rules that fail
        commits (deny TODO, forbid debugger statements, etc.).
      '';
    };

    installGitHook = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Install a global pre-commit hook under ~/.config/git/hooks and set
        core.hooksPath. The hook runs profile-level hooks first, then the
        project's .pre-commit-config.yaml / prek.toml if present.

        Only the pre-commit stage is wired globally. For other stages use
        `prek install --hook-type <stage>` per project.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = {
      "prek/profile.yaml".source = profileConfigFile;
    } // lib.optionalAttrs cfg.installGitHook {
      "${hooksRelDir}/pre-commit" = {
        executable = true;
        text = preCommitScript;
      };
    };

    programs.git = lib.mkIf cfg.installGitHook {
      enable = lib.mkDefault true;
      settings.core.hooksPath = hooksAbsDir;
    };
  };
}
