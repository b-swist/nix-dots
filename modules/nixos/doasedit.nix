{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.security.doas.doasedit;
in
{
  options.security.doas.doasedit = {
    enable = lib.mkEnableOption "Edit files as root using an unprivileged editor";
    package = lib.mkPackageOption pkgs "doasedit" { };
  };

  config = lib.mkIf cfg.enable { environment.systemPackages = [ cfg.package ]; };
}
