{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/be7ef614-64ac-4dc8-a133-606f2256467a";
      fsType = "ext4";
     };

    "/boot" = {
      device = "/dev/disk/by-uuid/946C-A7B9";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/6b807bea-3e3c-4526-beb9-b3d5d8715271"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  systemd.services.suspend-fix = {
    enable = true;
    description = "Workaround for Gigabyte B550 suspend bug";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "sudo /bin/sh -c \"echo GPP0 > /proc/acpi/wakeup\"";
    };
    wantedBy = [ "multi-user.target" ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
