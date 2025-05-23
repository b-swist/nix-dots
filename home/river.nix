{pkgs, ...}: {
  # imports = [];

  # home.packages = with pkgs; [ ];

  wayland.windowManager.river = {
    enable = true;
    settings = {
      keyboard-layout = "pl";
      default-layout = "rivertile";
      map.normal = {
        "Super Return" = "spawn foot";
        "Super Q" = "close";
        "Super+Shift Q" = "exit";
        "Super Space" = "toggle-float";
        "Super F" = "toggle-fullscreen";

        "Super J" = "focus-view next";
        "Super K" = "focus-view previous";
        "Super+Shift J" = "swap next";
        "Super+Shift K" = "swap previous";

        "Super+Alt H" = "move left 100";
        "Super+Alt J" = "move down 100";
        "Super+Alt K" = "move up 100";
        "Super+Alt L" = "move right 100";

        "Super+Alt+Control H" = "snap left";
        "Super+Alt+Control J" = "snap down";
        "Super+Alt+Control K" = "snap up";
        "Super+Alt+Control L" = "snap right";

        "Super+Alt+Shift H" = "resize horizontal -100";
        "Super+Alt+Shift J" = "resize vertical 100";
        "Super+Alt+Shift K" = "resize vertical -100";
        "Super+Alt+Shift L" = "resize horizontal 100";
      };
      map-pointer.normal = {
        "Super BTN_LEFT" = "move-view";
        "Super BTN_RIGHT" = "resize-view";
      };
    };
  };
}
