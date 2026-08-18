{
  flake.nixosModules.base = { lib, pkgs, ... }: {
    nix.settings = {
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
    };

    time.timeZone = lib.mkDefault "Europe/Warsaw";
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
    console.keyMap = lib.mkDefault "pl";

    services.dbus.implementation = lib.mkDefault "broker";

    programs.nh.enable = true;

    environment.systemPackages = with pkgs; [
      wget
      neovim
    ];
  };
}
