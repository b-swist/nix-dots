{
  flake.homeModules.git = { lib, ... }: {
    programs = {
      gh.enable = lib.mkDefault true;

      git = {
        enable = true;

        settings = {
          branch.sort = "-committerdate";
          diff = {
            algorithm = "histogram";
            colorMoved = "default";
            colorMovedWS = "allow-indentation-change";
          };
          help.autocorrect = "prompt";
          init.defaultBranch = "main";
          log.date = "iso";
          merge.conflictStyle = "diff3";
          push.autoSetupRemote = true;

          alias = {
            last = "log -1 HEAD";
            amend = "commit --amend";
            plog = "log --graph --abbrev-commit --pretty=short --decorate";
          };
        };
      };
    };
  };
}
