{
  self,
  ...
}:
{
  flake.nixosModules.laptop =
    {
      pkgs,
      ...
    }:
    {
      imports = with self.nixosModules; [
        desktop
        wifi
        bluetooth
        powersaving
      ];

      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.lsbat
      ];
    };
}
