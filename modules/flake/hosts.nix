{
  config,
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mapAttrsToList
    mkDefault
    ;

  mkSystem =
    host: attrs:
    let
      defaultHostModule = {
        system = { inherit (attrs) stateVersion; };
        hardware.enableRedistributableFirmware = mkDefault true;
        networking.hostName = mkDefault attrs.hostname;
        nixpkgs.pkgs = withSystem attrs.system ({ pkgs, ... }: pkgs);
      };

      mkUserModule = user: cfg: {
        users.users.${user} = {
          isNormalUser = mkDefault true;
        }
        // cfg;
      };

      userModules = mapAttrsToList (user: cfg: mkUserModule user cfg) attrs.users;
    in
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        defaultHostModule
        self.nixosModules.${host}
        inputs.nixpkgs.nixosModules.readOnlyPkgs
      ]
      ++ userModules
      ++ attrs.extraModules;
    };

  hostsSubmodule = types.submodule (
    { name, ... }: {
      options = {
        extraModules = mkOption {
          type = with types; listOf deferredModule;
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
        hostname = mkOption {
          type = types.str;
          default = name;
        };
      };
    }
  );
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
