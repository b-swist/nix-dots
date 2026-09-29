{
  flake.nixosModules.bluetooth = { pkgs, ... }: {
    hardware.bluetooth.enable = true;
    environment.systemPackages = with pkgs; [
      bluetui
    ];
  };
}
