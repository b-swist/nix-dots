{
  pkgs,
  settings,
  ...
}: {
  imports = [./hardware-configuration.nix];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = settings.hostname;
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pl";

  users.users.${settings.username} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    # packages = with pkgs; [ ];
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
    gnumake
    pavucontrol
    libnotify
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.symbols-only
    twitter-color-emoji
    liberation_ttf
    maple-mono.truetype
  ];

  services = {
    # xserver.enable = true;
    printing.enable = true; # CUPS
    udisks2.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  system.stateVersion = "24.11";
}
