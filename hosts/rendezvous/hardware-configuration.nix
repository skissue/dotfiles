{lib, ...}: {
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "btrfs";
    options = ["compress=zstd:1" "ssd" "noatime"];
  };
  swapDevices = [
    {device = "/dev/vda2";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
  virtualisation.hypervGuest.enable = true;
}
