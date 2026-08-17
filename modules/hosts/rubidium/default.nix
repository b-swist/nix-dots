{
  self,
  ...
}:
{
  nixosHosts.rubidium = {
    users.snowy = {
      enable = true;
      wheel = true;
      extraGroups = [ "dialout" ];
    };
    extraModules = with self.nixosModules; [ uefi ];
  };
}
