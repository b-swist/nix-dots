{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./bash.nix
    ./firefox.nix
    ./nvim.nix
  ];

  home = {
    username = "anon";
    homeDirectory = "/home/anon";
    stateVersion = "24.11";
    # packages = [];
    # file = {};
    # sessionVariables = {};
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "b-swist";
      userEmail = "bswist@protonmail.com";
      extraConfig.init.defaultBranch = "main";
    };
  };
}
