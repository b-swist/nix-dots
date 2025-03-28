{ config, pkgs, ... }:

{
  imports = [
    ./sway.nix
    ./firefox.nix
    ./sh.nix
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
