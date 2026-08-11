{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    neovim
    lua-language-server
    stylua
    bash-language-server
    shfmt
    haskell-language-server
    svelte-language-server
    typescript-language-server
    prettier
    tinymist
    clang-tools
    gopls
    nixd
    alejandra
    (python3.withPackages (
      p: with p; [
        python-lsp-server
        # python-lsp-black
        black
      ]
    ))
  ];

  xdg.configFile.neovim = {
    recursive = true;
    source = "${inputs.dotfiles}/nvim";
    target = "nvim";
  };
}
