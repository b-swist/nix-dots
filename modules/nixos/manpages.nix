{
  flake.nixosModules.mandoc = { config, ... }: {
    documentation.man = {
      man-db.enable = (!config.documentation.man.mandoc.enable);
      mandoc.enable = true;
    };
  };
}
