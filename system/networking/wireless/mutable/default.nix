{mkModulesList, ...}: {
  imports = mkModulesList ["networking/wireless"];

  networking.wireless = {
    userControlled = true;
    allowAuxiliaryImperativeNetworks = true;
  };

  my.user.extraGroups = ["wpa_supplicant"];

  systemd.tmpfiles.rules = [
    # For some reason NixOS sets imperative.conf to 664 so protect the main directory
    # <https://github.com/NixOS/nixpkgs/blob/1d060086d60cb76a40cf37109f979d88a5bd6396/nixos/modules/services/networking/wpa_supplicant.nix#L141>
    "d /etc/wpa_supplicant 0700 wpa_supplicant wpa_supplicant -"
  ];
}
