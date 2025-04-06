{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = lib.fileContents ./init.lua;
    extraPackages = with pkgs; [
      lua-language-server
      nixd
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      lualine-nvim
    ];
  };
}
