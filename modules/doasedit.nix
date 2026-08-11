{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.security.doas.doasedit;
in {
  options.security.doas.doasedit = {
    enable = mkEnableOption "Edit files as root using an unprivileged editor";
    package = mkPackageOption pkgs "doasedit" {};
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
  };
}
