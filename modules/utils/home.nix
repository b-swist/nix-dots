{ }
/*
  mkHome =
    {
      user,
      email ? null,
      extraModules ? [ ],
      name ? null,
    }:
    {
      flake.homeConfigurations.${user} = inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          {
            home = {
              username = user;
              homeDirectory = "/home/${user}";
            };
            programs = {
              home-manager.enable = lib.mkDefault true;
              git.settings.user = lib.mkMerge [
                (lib.mkIf (name != null) { name = lib.mkDefault name; })
                (lib.mkIf (email != null) { email = lib.mkDefault email; })
              ];
            };
          }
          (self.homeModules.${user} or null)
        ]
        ++ extraModules;
      };
    };
*/
