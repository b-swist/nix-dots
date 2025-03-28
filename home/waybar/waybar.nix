{ ... }:

{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings.bar = {
      layer = "top";
      position = "left";

      modules-left = [ "sway/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [
        "wireplumber"
        "tray"
      ];

      clock.format = "{:%H\n%M}";
      wireplumber.format = "{volume}%";
      tray.show-passive-items = true;
    };
  };
}
