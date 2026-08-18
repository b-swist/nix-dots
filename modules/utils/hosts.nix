{
  config,
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  inherit (lib) types mkOption;

  mkSystem =
    host:
    {
      extraModules,
      stateVersion,
      system,
      users,
    }:
    let
      defaultHostModule = {
        system = { inherit stateVersion; };
        networking.hostName = lib.mkDefault host;
        nixpkgs.pkgs = withSystem system ({ pkgs, ... }: pkgs);
      };

      mkUserModule = user: cfg: {
        users.users.${user} = {
          isNormalUser = lib.mkDefault true;
        }
        // cfg;
      };

      userModules = lib.mapAttrsToList (user: cfg: mkUserModule user cfg) users;
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        defaultHostModule
        self.nixosModules.${host}
        inputs.nixpkgs.nixosModules.readOnlyPkgs
      ]
      ++ userModules
      ++ extraModules;
    };

  hostsSubmodule = types.submodule {
    options = {
      extraModules = mkOption {
        type = types.listOf types.deferredModule;
        default = [ ];
        description = "Extra modules to include for this host";
      };
      users = mkOption {
        type = types.attrs;
        default = { };
      };
      stateVersion = mkOption {
        type = types.str;
        default = null;
      };
      system = mkOption {
        type = types.str;
        default = "x86_64-linux";
      };
    };
  };
in
{
  options.nixosHosts = mkOption {
    type = types.attrsOf hostsSubmodule;
    default = { };
  };

  config.flake.nixosConfigurations = builtins.mapAttrs (
    host: cfg: mkSystem host cfg
  ) config.nixosHosts;
}
