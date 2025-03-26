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
    description = "Worfaround for Gigabyte B550 suspend bug";
    unitConfig.Type = "oneshot";
    serviceConfig.ExecStart = "/bin/sh -c \"echo GPP0 > /proc/acpi/wakeup\"";
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
    packages = with pkgs; [
      slurp
      grim
      wl-clipboard
    ];
  };

  security.polkit.enable = true;

  hardware.graphics.enable = true;

  programs = {
    firefox.enable = true;
    # sway = {
    #   enable = true;
    #   wrapperFeatures.gtk = true;
    # };
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    wget
    texliveFull
    zathura
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

