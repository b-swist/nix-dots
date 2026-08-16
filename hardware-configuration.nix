{
  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
    ];
    kernelModules = [ "kvm-intel" ];

    kernelParams = [ "psmouse.synaptics_intertouch=1" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2b3a6c24-6db6-4c0c-8c7d-f00e5997a0c3";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/2b3a6c24-6db6-4c0c-8c7d-f00e5997a0c3";
      fsType = "btrfs";
      options = [
        "subvol=@home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/2b3a6c24-6db6-4c0c-8c7d-f00e5997a0c3";
      fsType = "btrfs";
      options = [
        "subvol=@nix"
        "compress=zstd"
        "noatime"
      ];
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/2b3a6c24-6db6-4c0c-8c7d-f00e5997a0c3";
      fsType = "btrfs";
      options = [
        "subvol=@log"
        "compress=zstd"
        "noatime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F395-8B8C";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/155d4c6c-7138-4e79-9e99-7f74be6e4acd"; } ];

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    trackpoint = {
      enable = true;
      sensitivity = 100;
      # drift_time = 25;
    };
  };
}
