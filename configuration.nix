{ pkgs, ... }:
let
  hostname = "rubidium";
  username = "snowy";
in
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    use-xdg-base-directories = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
  };

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pl";

  users.users.${username} = {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
  };

  security = {
    polkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      doasedit.enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          persist = true;
        }
      ];
    };
  };

  services = {
    displayManager = {
      enable = true;
      ly.enable = true;
    };

    dbus.implementation = "broker";
    printing.enable = true;
    libinput.enable = true;
    udisks2.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    tlp = {
      enable = true;
      pd.enable = true;
    };
  };

  documentation.man = {
    man-db.enable = false;
    mandoc.enable = true;
  };

  programs = {
    git.enable = true;
    nh.enable = true;
  };

  environment = {
    variables.MOZ_USE_XINPUT2 = 1;
    systemPackages = with pkgs; [
      wget
      acpi
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    nerd-fonts.symbols-only
    twitter-color-emoji
    input-fonts
    fira-code
  ];

  system.stateVersion = "26.05";
}
