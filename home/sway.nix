{ config, pkgs, ... }:

{
  imports = [
    ./waybar
    ./foot.nix
  ];

  home.packages = with pkgs; [
    slurp
    grim
    wl-clipboard
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "${pkgs.foot}/bin/foot";

      focus.followMouse = true;

      input."*" = {
        xkb_layout = "pl";
        accel_profile = "flat";
      };

      output."*" = {
        mode = "1920x1080@74.973Hz";
        position = "0,0";
        bg = "#ffffff solid_color";
      };

      gaps = {
        inner = 10;
        outer = 5;
      };

      bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];

      window = {
        border = 0;
        titlebar = false;
      };

      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        term = config.wayland.windowManager.sway.config.terminal;
        browser = "${pkgs.firefox}/bin/firefox";
        slurp = "${pkgs.slurp}/bin/slurp";
        grim = "${pkgs.grim}/bin/grim";
        wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
      in {
        "${mod}+q" = "kill";
        "${mod}+Tab" = "split toggle";
        "${mod}+Space" = "floating toggle";
        "${mod}+f" = "fullscreen";
        # "${mod}+Shift+r" = "reload";
        "${mod}+Shift+q" = "exec swaymsg exit";

        "${mod}+Return" = "exec ${term}";
        "${mod}+b" = "exec ${browser}";
        # bindsym $mod+d exec $menu
        "Print" = "exec ${slurp} | ${grim} -g - - | ${wl-copy}";

        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+minus" = "scratchpad show";
        "${mod}+Shift+minus" = "move scratchpad";

        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";
        "${mod}+6" = "workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+8" = "workspace 8";
        "${mod}+9" = "workspace 9";

        "${mod}+Shift+1" = "move workspace 1; workspace 1";
        "${mod}+Shift+2" = "move workspace 2; workspace 2";
        "${mod}+Shift+3" = "move workspace 3; workspace 3";
        "${mod}+Shift+4" = "move workspace 4; workspace 4";
        "${mod}+Shift+5" = "move workspace 5; workspace 5";
        "${mod}+Shift+6" = "move workspace 6; workspace 6";
        "${mod}+Shift+7" = "move workspace 7; workspace 7";
        "${mod}+Shift+8" = "move workspace 8; workspace 8";
        "${mod}+Shift+9" = "move workspace 9; workspace 9";

        "--locked XF86AudioNext" = "exec ${playerctl} next";
        "--locked XF86AudioPlay" = "exec ${playerctl} play-pause";
        "--locked XF86AudioPrev" = "exec ${playerctl} previous";

        "--locked XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "--locked XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1";
        "--locked XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1";
        "${mod}+r" = "mode resize";
      };

      modes.resize = {
        "Escape" = "mode default";
        "h" = "resize shrink width 10 px";
        "j" = "resize grow height 10 px";
        "k" = "resize shrink height 10 px";
        "l" = "resize grow width 10 px";
      };
    };
  };
}
