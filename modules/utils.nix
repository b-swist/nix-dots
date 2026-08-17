{
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  inherit (lib) types mkOption;

  mkSystem =
    host:
    {
      extraModules ? [ ],
      system ? "x86_64-linux",
      users ? { },
    }:
    let
      enabledUsers = lib.filterAttrs (u: v: v.enable) users;
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules.${host}
        {
          nixpkgs.hostPlatform = lib.mkDefault system;
        }
      ]
      ++ (lib.mapAttrsToList (
        user: cfg:
        self.nixosModules."${user}User" or mkUser {
          inherit user;
          inherit (cfg) wheel extraGroups;
        }
      ) enabledUsers)
      ++ extraModules;
    };

  mkUser =
    {
      user,
      extraGroups ? [ ],
      wheel ? true,
    }:
    {
      users.users.${user} = {
        extraGroups = extraGroups ++ (lib.optionals wheel [ "wheel" ]);
        createHome = true;
        isNormalUser = true;
      };
    }
  # // (mkHome {inherit user name email extraModules;})
  ;

  usersSubmodule = types.submodule
    {
      options = {
        enable = lib.mkEnableOption "user";
        wheel = mkOption {
          type = types.bool;
          default = false;
          example = true;
          description = "Whether to add user to wheel group";
        };
        extraGroups = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [
            "networkmanager"
            "dialout"
          ];
          description = "Additional groups user should belong to";
        };
      };
    }
  ;
in
{
  options.nixosHosts = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          extraModules = mkOption {
            type = types.listOf types.deferredModule;
            default = [ ];
            description = "Extra modules to include for this host";
          };
          users = mkOption {
            type = types.attrsOf usersSubmodule;
            default = { };
          };
        };
      }
    );
    default = { };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    host: cfg: mkSystem host cfg
  ) config.nixosHosts;
}
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
