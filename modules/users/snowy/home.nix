{ self, ... }: {
  homeUsers.snowy = {
    name = "Bartosz Świst";
    email = "bswist@protonmail.com";
    hosts.rubidium = {
      stateVersion = "26.05";
      extraModules = with self.homeModules; [
        base
        shell
        ssh
        apps
        gpg
        git
        niri
        foot
      ];
    };
  };
}
