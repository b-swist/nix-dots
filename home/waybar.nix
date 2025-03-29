{ ... }:

{
  programs.waybar = {
    enable = true;
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

    style = ''
      * {
        all: unset;
      }

      window#waybar {
        background-color: #000000;
        color: #ffffff;
      }
    '';
  };
}
