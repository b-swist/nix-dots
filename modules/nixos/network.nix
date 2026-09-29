{ self, ... }: {
  flake.nixosModules = {
    wifi = { lib, pkgs, ... }: {
      imports = [
        self.nixosModules.network
      ];

      networking.wireless.iwd.enable = true;

      environment.systemPackages = with pkgs; [
        impala
      ];
    };

    network = { pkgs, ... }: {
      networking.dhcpcd.enable = true;
    };
  };
}
