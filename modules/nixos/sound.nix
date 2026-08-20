{
  flake.nixosModules.pipewire = { config, lib, ... }: {
    services.pipewire =
      let
        cfg = config.services.pipewire.enable;
      in
      {
        enable = lib.mkDefault true;
        alsa.enable = cfg;
        pulse.enable = cfg;
      };
  };
}
