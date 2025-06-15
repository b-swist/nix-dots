{pkgs, ...}: {
  home.packages = with pkgs; [
    pdfdiff
  ];

  programs.git = {
    enable = true;

    userName = "b-swist";
    userEmail = "bswist@protonmail.com";

    attributes = [
      "*.pdf diff=pdf"
    ];

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
        pdf = {
          textconv = "${pkgs.pdfdiff}/bin/pdfdiff";
          binary = true;
          cachetextconv = true;
        };
      };
    };
  };
}
