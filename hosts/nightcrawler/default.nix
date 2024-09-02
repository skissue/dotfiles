{
  mkModulesList,
  pkgs,
  inputs,
  ...
}: {
  imports =
    [inputs.nixos-hardware.nixosModules.framework-13th-gen-intel]
    ++ mkModulesList [
      "home-manager"
      "desktop"
      "hardware/secure-boot"
      "networking/wireless"
      "networking/mullvad"
      "syncthing"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  security.protectKernelImage = false; # Disallows hibernation
  networking.firewall.allowedTCPPorts = [19000]; # Expo CLI

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/96a003b2-3726-4c70-ad21-dd775eeb2b89";
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7ac56432-cbd8-46cd-9a7d-227ff13607f2";
    fsType = "btrfs";
    options = ["subvol=root" "noatime" "compress=zstd" "ssd"];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/7ac56432-cbd8-46cd-9a7d-227ff13607f2";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress=zstd" "ssd"];
  };
  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/7ac56432-cbd8-46cd-9a7d-227ff13607f2";
    fsType = "btrfs";
    options = ["subvol=swap" "noatime" "ssd"];
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/8642-5A9A";
    fsType = "vfat";
  };
  swapDevices = [{device = "/swap/swapfile";}];

  boot.kernelParams = [
    "resume=UUID=7ac56432-cbd8-46cd-9a7d-227ff13607f2"
    "resume_offset=31897344"
  ];
  boot.resumeDevice = "/dev/disk/by-uuid/7ac56432-cbd8-46cd-9a7d-227ff13607f2";

  # State version (copy from auto-generated configuration.nix during install)
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
