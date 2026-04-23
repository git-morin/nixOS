{ pkgs, ... }:
let
  # Ghostty config search path differs per OS:
  #   macOS: ~/Library/Application Support/com.mitchellh.ghostty/config
  #   Linux: $XDG_CONFIG_HOME/ghostty/config (defaults to ~/.config/ghostty/config)
  configRelPath =
    if pkgs.stdenv.isDarwin
    then "Library/Application Support/com.mitchellh.ghostty/config"
    else ".config/ghostty/config";

  configText = ''
    # Font
    font-family = JetBrainsMono Nerd Font
    font-size = 14

    # Theme
    theme = catppuccin-mocha

    # Window
    window-padding-x = 8
    window-padding-y = 8
    window-save-state = always
    confirm-close-surface = false

    # macOS
    macos-option-as-alt = true
    macos-titlebar-style = tabs

    # Shell integration
    shell-integration = detect
    shell-integration-features = cursor,sudo,title

    # Cursor
    cursor-style = block
    cursor-style-blink = false

    # Clipboard
    copy-on-select = true
    clipboard-read = allow
    clipboard-write = allow
  '';
in
{
  home.file.${configRelPath}.text = configText;
}
