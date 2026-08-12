{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkPackageModule =
    name: desc:
    let
      cfg = config.programs.${name};
    in
    {
      options.programs.${name} = {
        enable = lib.mkEnableOption desc;
        package = lib.mkPackageOption pkgs name { };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ cfg.package ];
      };
    };
in
{
  imports = [
    (mkPackageModule "runny" "Application launcher in your terminal")
    (mkPackageModule "tree" "Command to produce a depth indented directory listing")
    (mkPackageModule "brightnessctl" "Read and control device brightness")
  ];
}
