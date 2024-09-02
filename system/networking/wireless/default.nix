{
  networking.networkmanager = {
    enable = true;
    wifi.macAddress = "random";
    ethernet.macAddress = "random";
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
