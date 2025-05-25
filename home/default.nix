{
  pkgs,
  settings,
  inputs,
  ...
}: let
  home = "/home/${settings.username}";
in {
  imports = [
    ./sway.nix
    ./bash.nix
    # ./firefox.nix
    ./river
    inputs.nix-nvim.homeModules.default
  ];

  home = {
    inherit (settings) username;
    homeDirectory = home;
    preferXdgDirectories = true;
    stateVersion = "24.11";
    packages = with pkgs; [
      tree
    ];
    # file = {};
    # sessionVariables = {};
  };

  xdg = {
    enable = true;
    configHome = "${home}/.config";
    cacheHome = "${home}/.cache";
    dataHome = "${home}/.local/share";
    stateHome = "${home}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${home}/desktop";
      documents = "${home}/documents";
      download = "${home}/downloads";
      music = "${home}/music";
      pictures = "${home}/pictures";
      templates = "${home}/templates";
      publicShare = "${home}/public";
      videos = "${home}/videos";
    };
  };

  nixCats = {
    enable = true;
    packageNames = ["cvim"];
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "b-swist";
      userEmail = "bswist@protonmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    ssh.enable = true;
    zathura.enable = true;
    tmux.enable = true;
    firefox.enable = true;
  };
}
