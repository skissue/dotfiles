{
  pkgs,
  mkModulesList,
  ...
}: {
  imports =
    [
      ./disko.nix
      ./llama-swap.nix
      ./printing.nix
      ./sunshine.nix
    ]
    ++ mkModulesList [
      "home-manager"
      "desktop"
      "hardware/cachyos-kernel"
      "hardware/secure-boot"
      "networking/airvpn"
      "networking/wireless"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/home/ad/BigBoiStorage" = {
    device = "/dev/disk/by-label/bigboistorage";
    fsType = "btrfs";
    options = ["compress=zstd:1" "noatime" "nofail" "autodefrag" "nossd"];
  };

  boot.initrd.systemd.enable = true;

  nixpkgs.config.rocmSupport = true;

  virtualisation.waydroid.enable = true;

  services.hardware.openrgb.enable = true;

  # When I need a single Flatpak that's not available any other way because it's
  # not open-source 💔.
  services.flatpak.enable = true;

  networking.firewall.allowedTCPPorts = [21000 21013];
  networking.firewall.allowedUDPPorts = [21003];

  # State version (copy from auto-generated configuration.nix during install)
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05";
}
