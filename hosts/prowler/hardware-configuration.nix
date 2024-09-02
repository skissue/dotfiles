{lib, ...}: {
  hardware.enableRedistributableFirmware = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = ["dm-snapshot"];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  powerManagement.cpuFreqGovernor = "powersave";

  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
