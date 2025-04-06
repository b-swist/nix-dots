{ pkgs, settings, ... }:

{
  imports = [
    ./sway.nix
    ./bash.nix
    # ./firefox.nix
    ./nvim
  ];

  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.11";
    packages = with pkgs; [
      zathura
    ];
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
