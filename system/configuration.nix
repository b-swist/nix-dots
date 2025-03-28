{ config, lib, pkgs, ... }:

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

  systemd.services.suspend-fix = {
    enable = true;
    description = "Workaround for Gigabyte B550 suspend bug";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c \"echo GPP0 > /proc/acpi/wakeup\"";
    };
    wantedBy = [ "multi-user.target" ];
  };

  networking = {
    hostName = "strontium-pc";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  users.users.anon = {
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
    texliveFull
    zathura
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
  ];

  services = {
    # xserver.enable = true;
    printing.enable = true; #CUPS
    udisks2.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  system.stateVersion = "24.11";
}

