{
  networking.wireless = {
    enable = true;
    extraConfig = ''
      mac_addr=1
      preassoc_mac_addr=1
    '';
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
