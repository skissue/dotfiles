{
  mkModulesList,
  pkgs,
  ...
}: {
  imports =
    [
      ./annex
      ./disko.nix
      ./freshrss
      ./iperf
      ./koito
      ./media
      ./nginx
      ./notes-publish
      ./postgresql
      ./remote-luks-unlock
      ./unbound
      ./wireless
    ]
    ++ mkModulesList [
      "hardware/secure-boot"
      "impermanence"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  security.sudo-rs.wheelNeedsPassword = false;

  services.fwupd.enable = true;

  services.tailscale = {
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--advertise-exit-node"
      "--advertise-routes"
      "fd7a:115c:a1e0:b1a:0:1:a00:0/120"
    ];
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
