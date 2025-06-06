{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./foot.nix];

  home.packages = with pkgs; [
    river
    wbg

    wl-clipboard
    slurp
    grim

    libnotify
    playerctl
  ];

  programs.bash.profileExtra = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ $(tty) = "/dev/tty1" ]; then
      exec ${pkgs.river}/bin/river
    fi
  '';

  services.mako.enable = true;

  wayland.windowManager.river = let
    term = "${pkgs.foot}/bin/foot";
    browser = "${pkgs.firefox}/bin/firefox";

    rivertile = "${pkgs.river}/bin/rivertile";
    wbg = "${pkgs.wbg}/bin/wbg";

    grim = "${pkgs.grim}/bin/grim";
    slurp = "${pkgs.slurp}/bin/slurp";

    notify-send = "${pkgs.libnotify}/bin/notify-send";
    wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    playerctl = "${pkgs.playerctl}/bin/playerctl";
  in {
    enable = true;
    settings = {
      keyboard-layout = "pl";
      set-repeat = "50 400";
      border-width = 0;

      spawn = [
        "'${wbg} ${config.xdg.userDirs.pictures}/something.jpg'"
        rivertile
      ];
      default-layout = "rivertile";

      map = let
        mediaKeysBinds = {
          "None XF86AudioMute" = "spawn '${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle'";
          "None XF86AudioLowerVolume" = "spawn '${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1'";
          "None XF86AudioRaiseVolume" = "spawn '${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1'";
          "None XF86AudioNext" = "spawn '${playerctl} next'";
          "None XF86AudioPlay" = "spawn '${playerctl} play-pause'";
          "None XF86AudioPrev" = "spawn '${playerctl} previous'";
        };
      in {
        normal =
          {
            "Super Q" = "close";
            "Super+Shift Q" = "exit";
            "Super Return" = "spawn ${term}";
            "Super B" = "spawn ${browser}";

            "Super+Shift Return" = "zoom";
            "Super F" = "toggle-fullscreen";
            "Super Space" = "toggle-float";

            "Super J" = "focus-view next";
            "Super K" = "focus-view previous";
            "Super+Shift J" = "swap next";
            "Super+Shift K" = "swap previous";

            "Super H" = "send-layout-cmd ${rivertile} 'main-ratio -0.05'";
            "Super L" = "send-layout-cmd ${rivertile} 'main-ratio +0.05'";
            "Super+Shift H" = "send-layout-cmd ${rivertile} 'main-count +1'";
            "Super+Shift L" = "send-layout-cmd ${rivertile} 'main-count -1'";

            "Super+Shift+Control H" = "send-layout-cmd ${rivertile} 'main-location left'";
            "Super+Shift+Control J" = "send-layout-cmd ${rivertile} 'main-location bottom'";
            "Super+Shift+Control K" = "send-layout-cmd ${rivertile} 'main-location top'";
            "Super+Shift+Control L" = "send-layout-cmd ${rivertile} 'main-location right'";

            "None Print" = "spawn '${slurp} | ${grim} -g - - | ${wl-copy} && ${notify-send} \"Screenshot taken\"'";
          }
          // mediaKeysBinds
          // (
            let
              pow = a: n:
                if n == 0
                then 1
                else if n == 1
                then a
                else a * pow a (n - 1);

              tag = n: toString (pow 2 (n - 1));
              allTags = toString (pow 2 9 - 1);
              scratchTag = tag 10;
            in
              {
                "Super Minus" = "toggle-focused-tags ${scratchTag}";
                "Super+Shift Minus" = "set-view-tags ${scratchTag}";
                "Super 0" = "set-focused-tags ${allTags}";
                "Super+Shift 0" = "set-view-tags ${allTags}";
              }
              // (
                lib.zipAttrs (
                  map (n: let
                    key = toString n;
                  in {
                    "Super ${key}" = "set-focused-tags ${tag n}";
                    "Super+Shift ${key}" = "set-view-tags ${tag n}";
                    "Super+Control ${key}" = " toggle-focused-tags ${tag n}";
                    "Super+Shift+Control ${key}" = " toggle-view-tags ${tag n}";
                  }) (lib.range 1 9)
                )
              )
          );
        locked = mediaKeysBinds;
      };

      map-pointer.normal = {
        "Super BTN_LEFT" = "move-view";
        "Super BTN_RIGHT" = "resize-view";
      };
    };
  };
}
