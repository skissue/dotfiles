{mkModulesList, ...}: {
  imports = mkModulesList ["networking/wireless"];

  networking = {
    # NetworkManager handles DHCP
    useDHCP = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi = {
        backend = "wpa_supplicant";
        macAddress = "random";
        scanRandMacAddress = true;
      };
      settings.keyfile.path = "/var/lib/NetworkManager/system-connections";
    };
  };

  # Use NetworkManager instead of networkd for online check
  # <https://github.com/NixOS/nixpkgs/blob/76abcfc873caee1b9b22c12d34b92f0d6dea1c1b/nixos/modules/system/boot/networkd.nix#L4096-L4109>
  systemd.network.wait-online.enable = false;

  my.user.extraGroups = ["networkmanager"];

  my.persist.local.directories = ["/var/lib/NetworkManager"];
}
