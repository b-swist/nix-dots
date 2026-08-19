{
  flake.homeModules.shell =
    { config, lib, ... }:
    let
      bashEnabled = config.programs.bash.enable;
    in
    {
      programs = {
        bash.enable = true;

        ripgrep.enable = lib.mkDefault true;
        fd.enable = lib.mkDefault true;

        readline = {
          enable = lib.mkDefault true;
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
          enable = lib.mkDefault true;
          enableBashIntegration = bashEnabled;
        };
        direnv = {
          enable = lib.mkDefault true;
          enableBashIntegration = bashEnabled;
          nix-direnv.enable = config.programs.direnv.enable;
        };
      };
    };
}
