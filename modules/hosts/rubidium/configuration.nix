{
  self,
  ...
}:
{
  nixosHosts.rubidium = {
    users.snowy.extraGroups = [
      "wheel"
      "dialout"
    ];
    extraModules = with self.nixosModules; [
      uefi
      printing
      laptop
    ];
    stateVersion = "26.05";
  };
}
