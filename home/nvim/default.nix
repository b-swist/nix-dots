{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraLuaConfig = lib.fileContents ./init.lua;
    extraPackages = with pkgs; [
      lua-language-server
      haskell-language-server
      nixd
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      # telescope
      # vimtex
      nvim-autopairs
    ];
  };
}
