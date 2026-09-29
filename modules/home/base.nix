{
  flake.homeModules.base = { lib, osConfig, ... }: {
    services.udiskie.enable = lib.mkDefault osConfig.services.udisks2.enable;
  };
}
