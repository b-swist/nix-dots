{
  self,
  ...
}:
{
  flake.nixosModules.desktop = { lib, pkgs, ... }: {
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

    hardware.graphics.enable = true;

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      twitter-color-emoji
      input-fonts
    ];
  };
}
