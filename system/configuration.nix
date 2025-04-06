{ config, lib, pkgs, settings, ... }:

{
  imports = [ ./hardware-configuration.nix ];

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
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  users.users.${settings.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    # packages = with pkgs; [ ];
  };

  security.polkit.enable = true;
  hardware.graphics.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
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

