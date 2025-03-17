{
  mkModulesList,
  pkgs,
  ...
}: {
  imports =
    [
      ./anki-sync-server
      ./annex
      ./disko.nix
      ./remote-luks-unlock
      ./media
      ./tt-rss
      ./wireless
    ]
    ++ mkModulesList [
      "hardware/secure-boot"
      "impermanence"
      "syncthing"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.doas.wheelNeedsPassword = false;

  services.syncthing = {
    user = "syncthing";
    dataDir = "/var/lib/syncthing";
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };

  # State version (copy from auto-generated configuration.nix during install)
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
