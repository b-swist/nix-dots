{
  pkgs,
  config,
  settings,
  ...
}: {
  imports = [
    ./sway.nix
    ./bash.nix
    # ./firefox.nix
    ./river.nix
  ];

  home = {
    username = settings.username;
    homeDirectory = "/home/${settings.username}";
    stateVersion = "24.11";
    # packages = with pkgs; [];
    # file = {};
    # sessionVariables = {};
  };

  xdg.userDirs = let
    home = config.home.homeDirectory;
  in {
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

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "b-swist";
      userEmail = "bswist@protonmail.com";
      extraConfig.init.defaultBranch = "main";
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    fzf.enable = true;
    zathura.enable = true;
    tmux.enable = true;
    firefox.enable = true;
  };
}
