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
        powersaving
      ];

      environment.systemPackages = with pkgs; [
        acpi
      ];
    };
}
