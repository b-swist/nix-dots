{
  config,
  pkgs,
  ...
}:
let
  username = "snowy";
  homeDirectory = "/home/${username}";
in
{
  imports = [
    ./foot.nix
    ./git.nix
    ./neovim.nix
    ./gpg.nix
    ./niri.nix
  ];

  home = {
    inherit username;
    inherit homeDirectory;
    preferXdgDirectories = true;
    stateVersion = "26.05";
    packages = with pkgs; [
      openssh
    ];
  };

  xdg = {
    enable = true;

    binHome = "${homeDirectory}/.local/bin";
    localBinInPath = true;

    cacheHome = "${homeDirectory}/.cache";
    configHome = "${homeDirectory}/.config";
    dataHome = "${homeDirectory}/.local/share";
    stateHome = "${homeDirectory}/.local/state";

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      # bashrcExtra = builtins.readFile "${dotfiles}/bashrc";
    };

    runny.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    tree.enable = true;

    readline = {
      enable = true;
      bindings = {
        "\\C-l" = "clear-display";
        "\\e[A" = "history-search-backward";
        "\\e[B" = "history-search-forward";
        "\\e[Z" = "menu-complete-backward";
        "\\e\\C-k" = "kill-whole-line";
        "\\t" = "menu-complete";
      };
      variables = {
        blink-matching-paren = true;
        colored-completion-prefix = true;
        colored-stats = true;
        completion-ignore-case = true;
        completion-map-case = true;
        completion-prefix-display-length = 8;
        completion-query-items = 1000;
        echo-control-characters = false;
        enable-bracketed-paste = true;
        mark-symlinked-directories = false;
        menu-complete-display-prefix = true;
        show-all-if-ambiguous = true;
        show-all-if-unmodified = true;
        skip-completed-text = true;
        visible-stats = true;
      };
    };

    fzf = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
    };

    direnv = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      nix-direnv.enable = true;
    };

    tmux = {
      enable = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      mouse = true;
      shortcut = "b";
    };

    brightnessctl.enable = true;

    firefox.enable = true;
    zathura.enable = true;
  };
}
