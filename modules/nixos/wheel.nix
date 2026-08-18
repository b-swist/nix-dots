{
  flake.nixosModules = {
    doas = { config, lib, ... }: {
      security = {
        sudo.enable = lib.mkDefault (!config.security.doas.enable);
        doas = {
          enable = true;
          extraRules = [
            {
              groups = [ "wheel" ];
              persist = true;
            }
          ];
        };
      };
      programs.git.enable = config.security.doas.enable && (!config.programs.nh.enable);
    };
    sudo.security.sudo.enable = true;
  };
}
