{ self, ... }: {
  flake.nixosModules = {
    doasedit =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.security.doas.doasedit;
      in
      {
        options.security.doas.doasedit = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Edit files as root using an unprivileged editor";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = self.packages.${pkgs.stdenv.hostPlatform.system}.doasedit;
          };
        };

        config = lib.mkIf cfg.enable { environment.systemPackages = [ cfg.package ]; };
      };

    doas =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ self.nixosModules.doasedit ];
        config = {
          security = {
            sudo.enable = lib.mkDefault (!config.security.doas.enable);
            doas = {
              enable = true;
              doasedit.enable = true;
              extraRules = [
                {
                  groups = [ "wheel" ];
                  persist = true;
                }
              ];
            };
          };
          programs.git.enable = lib.mkDefault (config.security.doas.enable && (!config.security.sudo.enable));
        };
      };
  };
}
