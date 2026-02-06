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

  my.persist.local.directories = [
    # Default and owned by root:root.
    {
      directory = "/var/lib/iwd";
      mode = "700";
    }
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
}
