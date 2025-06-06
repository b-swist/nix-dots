{pkgs, ...}: {
  android-integration = {
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
  };

  environment = {
    packages = with pkgs; [
      neovim
    ];
    motd = null;
  };

  # home-manager = {
  # config = ../../home/android;
  # extraSpecialArgs = {};
  # backupFileExtension = "bak";
  # useGlobalPkgs = true;
  # };

  time.timeZone = "Europe/Warsaw";
  system.stateVersion = "24.05";
}
