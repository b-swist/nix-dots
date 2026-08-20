{
  flake.homeModules.apps = {pkgs, ...}: {
    home.packages = with pkgs; [
      tree
    ];

    programs.zathura.enable = true;
  };
}
