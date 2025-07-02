{
  pkgs,
  mkModulesList,
  ...
}: {
  imports =
    [./disko.nix ./printing.nix ./sunshine.nix]
    ++ mkModulesList [
      "home-manager"
      "desktop"
      "hardware/secure-boot"
      "networking/wireless"
      "networking/mullvad"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/home/ad/BigBoiStorage" = {
    device = "/dev/disk/by-label/bigboistorage";
    fsType = "btrfs";
    options = ["compress=zstd:1" "noatime" "nofail" "autodefrag" "nossd"];
  };

  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  nixpkgs.config.rocmSupport = true;

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    rocmOverrideGfx = "11.0.1";
  };

  virtualisation.waydroid.enable = true;

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
