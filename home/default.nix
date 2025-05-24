{
  pkgs,
  config,
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
    ./river.nix
    inputs.nix-nvim.homeModules.default
  ];

  home = {
    username = settings.username;
    homeDirectory = home;
    stateVersion = "24.11";
    packages = with pkgs; [
      tree
    ];
    # file = {};
    # sessionVariables = {};
  };

  xdg.userDirs = {
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

  services = {
    ssh-agent.enable = true;
  };

  nixCats = {
    enable = true;
    packageNames = ["cvim"];
  };

  programs = {
    home-manager.enable = true;

    ssh = {
      enable = true;
      addKeysToAgent = "confirm";
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "${home}/.ssh/keys/github";
        };
      };
    };

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

    zathura.enable = true;
    tmux.enable = true;
    firefox.enable = true;
  };
}
