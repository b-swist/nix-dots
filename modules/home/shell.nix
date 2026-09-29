{
  flake.homeModules.shell =
    { config, lib, ... }:
    let
      inherit (lib) mkDefault mkIf;
    in
    {
      home.shell.enableBashIntegration = mkDefault true;

      programs = {
        bash = {
          enable = true;
          historyFile = mkIf config.home.preferXdgDirectories "${config.xdg.stateHome}/bash/history";
        };

        jq.enable = mkDefault true;
        fzf.enable = mkDefault true;
        ripgrep.enable = mkDefault true;
        fd.enable = mkDefault true;

        readline = {
          enable = mkDefault true;
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

        direnv = {
          enable = mkDefault true;
          nix-direnv.enable = config.programs.direnv.enable;
        };
      };
    };
}
