{
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General = {
        EnableNetworkConfiguration = "true";
        AddressRandomization = "network";
      };
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
