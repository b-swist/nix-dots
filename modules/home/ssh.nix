{
  flake.homeModules.ssh =
    {
      config,
      lib,
      pkgs,
      osConfig,
      ...
    }:
    {
      programs.ssh = {
        enable = true;
        package = lib.mkIf (!osConfig.services.openssh.enable) pkgs.openssh;
        enableDefaultConfig = false;
        settings."github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "${config.home.homeDirectory}/.ssh/github";
        };
      };
    };
}
