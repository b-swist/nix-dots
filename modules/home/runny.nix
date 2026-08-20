{ self, ... }: {
  flake.homeModules = {
    runny =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.programs.runny;
      in
      {
        options.programs.runny = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Application launcher in your terminal";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.stdenv.hostPlatform.system}.runny;
          };
        };

        config = lib.mkIf cfg.enable { home.packages = [ cfg.package ]; };
      };
    apps = { lib, ... }: {
      imports = [ self.homeModules.runny ];
      config.programs.runny.enable = lib.mkDefault true;
    };
  };
}
