{
  config,
  lib,
  inputs,
  withSystem,
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
    user: host: userCfg: hostCfg:
    let
      system = config.nixosHosts.${host}.system;

      defaultHomeModule = {
        home = {
          inherit (hostCfg) stateVersion;
          username = user;
          homeDirectory = "/home/${user}";
        };
        programs = {
          home-manager.enable = true;
          git.settings.user = mkMerge [
            (mkIf (userCfg.name != null) { name = mkDefault userCfg.name; })
            (mkIf (userCfg.email != null) { email = mkDefault userCfg.email; })
          ];
        };
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ pkgs, ... }: pkgs);
      extraSpecialArgs.osConfig = config.flake.nixosConfigurations.${host}.config;
      modules = [
        defaultHomeModule
        # (self.homeModules.${user} or null)
        # self.homeModules.${user}
      ]
      ++ hostCfg.extraModules;
    };

  perHostUserSubmodule = types.submodule {
    options = {
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
  };

  userSubmodule = types.submodule (
    { name, ... }:
    {
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
        hosts = mkOption {
          type = types.attrsOf perHostUserSubmodule;
          default = { };
        };
      };
    }
  );
in
{
  options.homeUsers = mkOption {
    type = types.attrsOf userSubmodule;
    default = { };
  };

  config.flake.homeConfigurations = lib.concatMapAttrs (
    user: userCfg:
    lib.mapAttrs' (
      host: hostCfg: lib.nameValuePair "${user}@${host}" (mkHome user host userCfg hostCfg)
    ) userCfg.hosts
  ) config.homeUsers;
  # config.flake.homeConfigurations = builtins.mapAttrs (user: cfg: mkHome user cfg) config.homeUsers;
}
