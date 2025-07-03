{ pkgs, ... }:
{
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
  extraPlugins = with pkgs.vimPlugins; [
    nvim-web-devicons
  ];
  extraConfigLuaPre = ''
    if vim.g.have_nerd_font then
      require('nvim-web-devicons').setup {}
    end
  '';
  extraConfigLuaPost = ''
    -- vim: ts=2 sts=2 sw=2 et
  '';
}