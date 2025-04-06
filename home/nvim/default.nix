{ pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nixd
    ];
    extraLuaConfig = lib.fileContents ./init.lua;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        config = lib.fileContents ./plugins/lsp.lua;
        type = "lua";
      }
      nvim-treesitter.withAllGrammars
      {
        plugin = lualine-nvim;
        config = lib.fileContents ./plugins/lualine.lua;
        type = "lua";
      }
    ];
  };
}
