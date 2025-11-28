{
  lib,
  pkgs,
  inputs,
  mkModulesList,
  ...
}: {
  imports =
    [
      # Static network configuration for DigitalOcean, contains public IPs.
      inputs.private.nixosModules.iridescent-networking
      ./acme.nix
      ./disko.nix
    ]
    ++ mkModulesList [
      "impermanence"
      "impermanence/bcachefs.nix"
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = ["bcachefs"];

  services.do-agent.enable = true;

  # State version (copy from auto-generated configuration.nix during install)
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05";
}
