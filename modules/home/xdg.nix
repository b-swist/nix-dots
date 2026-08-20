{
  flake.homeModules.xdg =
    { config, lib, ... }:
    let
      home = config.home.homeDirectory;
    in
    {
      home.preferXdgDirectories = true;

      xdg = {
        enable = true;

        binHome = "${home}/.local/bin";
        localBinInPath = true;

        cacheHome = "${home}/.cache";
        configHome = "${home}/.config";
        dataHome = "${home}/.local/share";
        stateHome = "${home}/.local/state";

        userDirs = {
          enable = lib.mkDefault true;
          createDirectories = lib.mkDefault true;
        };
      };
    };
}
