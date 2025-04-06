{ ... }:

{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings.bar = {
      layer = "top";
      position = "left";
      width = 25;

      modules-left = [ "sway/workspaces" ];
      # modules-center = [];
      modules-right = [
        "clock"
        # "pulseaudio"
        # "tray"
      ];

      clock.format = "{:%H\n%M}";
    };
  };
}
