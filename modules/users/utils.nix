{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    mkMerge
    types
    ;

  mkHome =
    user: attrs: pkgs:
    let
      defaultHomeModule = {
        home = {
          inherit (attrs) stateVersion;
          username = user;
          homeDirectory = "/home/${user}";
        };
        programs = {
          home-manager.enable = true;
          git.settings.user = mkMerge [
            (mkIf (attrs.name != null) { name = mkDefault attrs.name; })
            (mkIf (attrs.email != null) { email = mkDefault attrs.email; })
          ];
        };
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        defaultHomeModule
        # (self.homeModules.${user} or null)
        # self.homeModules.${user}
      ]
      ++ attrs.extraModules;
    };

  usersSubmodule = types.submodule (
    { name, ... }: {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
        };
        email = mkOption {
          type = with types; nullOr str;
          example = "alice@example.com";
          default = null;
        };
        stateVersion = mkOption {
          type = types.str;
          example = "26.05";
        };
        extraModules = mkOption {
          type = types.listOf types.deferredModule;
          default = [ ];
          description = "Extra modules to include for this host";
        };
      };
    }
  );
in
{
  options.homeUsers = mkOption {
    type = types.attrsOf usersSubmodule;
    default = { };
  };

  config.perSystem = { pkgs, ... }: {
    legacyPackages.homeConfigurations = builtins.mapAttrs (
      host: cfg: mkHome host cfg pkgs
    ) config.homeUsers;
  };
}
