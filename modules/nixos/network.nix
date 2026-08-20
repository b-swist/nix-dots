{
  flake.nixosModules.wifi = { lib, ... }: {
    networking.networkmanager = {
      enable = lib.mkDefault true;
      wifi.backend = "iwd";
    };
  };
}
