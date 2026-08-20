{ self, ... }: {
  flake.homeModules.niri =
    {
      lib,
      pkgs,
      ...
    }:
    let
      browser = lib.getExe pkgs.firefox;
      terminal = lib.getExe pkgs.foot;
      launcher = [
        terminal
        "-e"
        # (lib.getExe pkgs.runny)
      ];
    in
    {
      imports = [
        self.homeModules.foot
      ];

      home.packages = with pkgs; [
        wl-clipboard
        brightnessctl
      ];

      wayland.windowManager.niri = {
        enable = true;
        settings = {
          input = {
            keyboard = {
              repeat-rate = 50;
              xkb.layout = "pl";
            };
            disable-power-key-handling = { };
            touchpad = {
              disabled-on-external-mouse = { };
              drag-lock = { };
              dwt = { };
              natural-scroll = { };
              tap = { };
            };
          };

          layout = {
            border.off = { };
            center-focused-column = "never";
            default-column-width.proportion = 0.5;
            focus-ring.off = { };
            gaps = 16;
            preset-column-widths._children = [
              { proportion = 0.25; }
              { proportion = 0.5; }
              { proportion = 0.75; }
            ];
            shadow = {
              # on = { };
              color = "#000007";
              draw-behind-window = true;
              offset._props = {
                x = 0;
                y = 5;
              };
              softness = 30;
              spread = 5;
            };
          };

          hotkey-overlay.skip-at-startup = { };
          prefer-no-csd = { };
          screenshot-path = null;

          _children = [
            {
              window-rule._children = [
                {
                  clip-to-geometry = true;
                  geometry-corner-radius = 12.;
                }
              ];
            }
            {
              window-rule._children = [
                {
                  match._props = {
                    app-id = "firefox";
                    title = "^Picture-in-Picture$";
                  };
                }
                { open-floating = true; }
              ];
            }
            {
              window-rule._children = [
                {
                  match._props = {
                    app-id = "firefox";
                    title = "Mozilla Firefox$";
                  };
                }
                {
                  default-column-width.proportion = 1.;
                  open-focused = true;
                }
              ];
            }
          ];

          binds =
            let
              brightnessctl = lib.getExe pkgs.brightnessctl;
              wpctl = lib.getExe' pkgs.wireplumber "wpctl";

              mkMediaBind = args: {
                _props.allow-when-locked = true;
                spawn = args;
              };

              mkScrollBind = action: {
                _props.cooldown-ms = 150;
                ${action} = { };
              };

              mkLaunchBind = app: title: {
                _props.hotkey-overlay-title = title;
                spawn = app;
              };
            in
            {
              "Mod+Shift+Slash".show-hotkey-overlay = { };

              "Mod+Shift+Q".quit = { };
              "Mod+Shift+P".power-off-monitors = { };

              "Mod+M".maximize-window-to-edges = { };
              "Mod+F".maximize-column = { };
              "Mod+Ctrl+F".expand-column-to-available-width = { };
              "Mod+Shift+F".fullscreen-window = { };

              "Mod+C".center-column = { };
              "Mod+Ctrl+C".center-visible-columns = { };

              "Mod+Escape" = {
                _props.allow-inhibiting = false;
                toggle-keyboard-shortcuts-inhibit = { };
              };

              "Mod+Equal".set-column-width = "+10%";
              "Mod+Minus".set-column-width = "-10%";

              "Mod+Shift+Equal".set-window-height = "+10%";
              "Mod+Shift+Minus".set-window-height = "-10%";

              "Mod+Space".toggle-window-floating = { };
              "Mod+Shift+Space".switch-focus-between-floating-and-tiling = { };

              "Mod+W".toggle-column-tabbed-display = { };

              "Print".screenshot = { };
              "Ctrl+Print".screenshot-window = { };
              "Shift+Print".screenshot-screen = { };

              "Mod+R".switch-preset-column-width = { };
              "Mod+Shift+R".switch-preset-column-width-back = { };
              "Mod+Ctrl+R".reset-window-height = { };
              "Mod+Ctrl+Shift+R".switch-preset-window-height = { };

              "Mod+BracketLeft".consume-or-expel-window-left = { };
              "Mod+BracketRight".consume-or-expel-window-right = { };
              "Mod+Comma".consume-window-into-column = { };
              "Mod+Period".expel-window-from-column = { };

              "Mod+Q" = {
                _props.repeat = false;
                close-window = { };
              };
              "Mod+O" = {
                _props.repeat = false;
                toggle-overview = { };
              };

              "Mod+Return" = mkLaunchBind terminal "Open Terminal";
              "Mod+B" = mkLaunchBind browser "Open Browser";
              "Mod+E" = mkLaunchBind launcher "Open Launcher";

              "Mod+H".focus-column-left = { };
              "Mod+J".focus-window-down = { };
              "Mod+K".focus-window-up = { };
              "Mod+L".focus-column-right = { };

              "Mod+Home".focus-column-first = { };
              "Mod+End".focus-column-last = { };

              "Mod+Ctrl+H".move-column-left = { };
              "Mod+Ctrl+J".move-window-down = { };
              "Mod+Ctrl+K".move-window-up = { };
              "Mod+Ctrl+L".move-column-right = { };

              "Mod+Ctrl+End".move-column-to-last = { };
              "Mod+Ctrl+Home".move-column-to-first = { };

              "Mod+Shift+H".focus-monitor-left = { };
              "Mod+Shift+J".focus-monitor-down = { };
              "Mod+Shift+K".focus-monitor-up = { };
              "Mod+Shift+L".focus-monitor-right = { };

              "Mod+Shift+Ctrl+H".move-column-to-monitor-left = { };
              "Mod+Shift+Ctrl+J".move-column-to-monitor-down = { };
              "Mod+Shift+Ctrl+K".move-column-to-monitor-up = { };
              "Mod+Shift+Ctrl+L".move-column-to-monitor-right = { };

              "Mod+U".focus-workspace-down = { };
              "Mod+I".focus-workspace-up = { };

              "Mod+Ctrl+U".move-column-to-workspace-down = { };
              "Mod+Ctrl+I".move-column-to-workspace-up = { };

              "Mod+Shift+U".move-workspace-down = { };
              "Mod+Shift+I".move-workspace-up = { };

              "Mod+WheelScrollDown" = mkScrollBind "focus-workspace-down";
              "Mod+WheelScrollUp" = mkScrollBind "focus-workspace-up";

              "Mod+Ctrl+WheelScrollDown" = mkScrollBind "move-column-to-workspace-down";
              "Mod+Ctrl+WheelScrollUp" = mkScrollBind "move-column-to-workspace-up";

              "Mod+Shift+WheelScrollDown" = mkScrollBind "focus-column-right";
              "Mod+Shift+WheelScrollUp" = mkScrollBind "focus-column-left";

              "Mod+Ctrl+Shift+WheelScrollDown" = mkScrollBind "move-column-right";
              "Mod+Ctrl+Shift+WheelScrollUp" = mkScrollBind "move-column-left";

              "XF86AudioMute" = mkMediaBind [
                wpctl
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
              "XF86AudioLowerVolume" = mkMediaBind [
                wpctl
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1-"
              ];
              "XF86AudioRaiseVolume" = mkMediaBind [
                wpctl
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1+"
                "-l"
                "1.0"
              ];
              "XF86AudioMicMute" = mkMediaBind [
                wpctl
                "set-mute"
                "@DEFAULT_AUDIO_SOURCE@"
                "toggle"
              ];

              "XF86MonBrightnessDown" = mkMediaBind [
                brightnessctl
                "-c"
                "backlight"
                "-n"
                "set"
                "10%-"
              ];
              "XF86MonBrightnessUp" = mkMediaBind [
                brightnessctl
                "-c"
                "backlight"
                "set"
                "+10%"
              ];
            }
            // (lib.mergeAttrsList (
              map (
                n:
                let
                  key = toString n;
                in
                {
                  "Mod+${key}".focus-workspace = n;
                  "Mod+Ctrl+${key}".move-column-to-workspace = n;
                }
              ) (lib.range 1 9)
            ));
        };
      };
    };
}
