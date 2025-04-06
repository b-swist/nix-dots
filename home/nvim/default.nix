{ pkgs, lib, ... }:

{
  home.file = {
    ".config/nvim/init.lua".source = ./init.lua;
    ".config/nvim/lua" = {
      source = ./lua;
      recursive = true;
    };
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nixd
    ];
    # extraLuaConfig = lib.fileContents ./init.lua;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      lualine-nvim
    ];
  };
}
