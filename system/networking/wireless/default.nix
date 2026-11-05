{
  networking.wireless = {
    enable = true;
    userControlled = true;
    allowAuxiliaryImperativeNetworks = true;
    extraConfig = ''
      mac_addr=1
      preassoc_mac_addr=1
    '';
  };

  my.user.extraGroups = ["wpa_supplicant"];

  systemd.tmpfiles.rules = [
    # For some reason NixOS sets imperative.conf to 664 so protect the main directory
    # <https://github.com/NixOS/nixpkgs/blob/1d060086d60cb76a40cf37109f979d88a5bd6396/nixos/modules/services/networking/wpa_supplicant.nix#L141>
    "d /etc/wpa_supplicant 0700 wpa_supplicant wpa_supplicant -"
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
