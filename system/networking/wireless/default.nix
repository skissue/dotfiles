{
  networking.wireless = {
    enable = true;
    extraConfig = ''
      mac_addr=1
      preassoc_mac_addr=1
    '';
  };

  boot.kernelParams = ["cfg80211.ieee80211_regdom=US"];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
