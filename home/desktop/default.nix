{
  pkgs,
  settings,
  inputs,
  ...
}: let
  homeDirectory = "/home/${settings.username}";
in {
  imports = [
    # ./sway.nix
    ./bash.nix
    # ./firefox.nix
    ./river.nix
    ./git.nix
    inputs.nix-nvim.homeModules.default
  ];

  home = {
    inherit (settings) username;
    inherit homeDirectory;
    preferXdgDirectories = true;
    stateVersion = "24.11";
    packages = with pkgs; [
      tree
      openssh
    ];
    # file = {};
    # sessionVariables = {};
  };

  xdg = {
    enable = true;
    configHome = "${homeDirectory}/.config";
    cacheHome = "${homeDirectory}/.cache";
    dataHome = "${homeDirectory}/.local/share";
    stateHome = "${homeDirectory}/.local/state";
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${homeDirectory}/desktop";
      documents = "${homeDirectory}/documents";
      download = "${homeDirectory}/downloads";
      music = "${homeDirectory}/music";
      pictures = "${homeDirectory}/pictures";
      templates = "${homeDirectory}/templates";
      publicShare = "${homeDirectory}/public";
      videos = "${homeDirectory}/videos";
    };
  };

  nixCats = {
    enable = true;
    packageNames = ["cvim"];
  };

  programs = {
    home-manager.enable = true;

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
