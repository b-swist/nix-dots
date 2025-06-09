{...}: {
  programs.git = {
    enable = true;

    userName = "b-swist";
    userEmail = "bswist@protonmail.com";

    # delta.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      merge.conflictStyle = "diff3";
      push.autoSetupRemote = true;
      help.autocorrect = "prompt";
      branch.sort = "-committerdate";
      log.date = "iso";
      diff = {
        algorithm = "histogram";
        colorMoved = "default";
        colorMovedWS = "allow-indentation-change";
      };
    };
  };
}
