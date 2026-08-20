{
  flake.nixosModules.powersaving = { config, lib, ... }: {
    services.tlp = {
      enable = true;
      pd.enable = config.services.tlp.enable;
    };
    networking.networkmanager.wifi.powersave = lib.mkDefault (config.networking.networkmanager.enable);
  };
}
