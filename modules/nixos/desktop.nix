{
  self,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      firefoxPipewirePkg = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        pipewireSupport = config.services.pipewire.enable;
      }) { };
    in
    {
      imports = with self.nixosModules; [
        base
        mandoc
        doas
        pipewire
      ];

      security.polkit.enable = true;
      services = {
        udisks2.enable = lib.mkDefault true;
        libinput.enable = lib.mkDefault true;
      };

      programs.firefox = {
        enable = true;
        package = firefoxPipewirePkg;
      };

      hardware.graphics.enable = true;

      # xdg = {
      #   portal = {
      #     enable = lib.mkDefault true;
      #     wlr.enable = true;
      #   };
      # };

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        twitter-color-emoji
      ];
    };
}
