{pkgs, ...}: {
  services.printing = {
    enable = true;
    drivers = with pkgs; [hplip];
  };

  # Enable scanning
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [sane-airscan];
    disabledDefaultBackends = [ "escl" ]; # Unneeded since airscan is enabled
  };

  # Networked devices
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  my.user.extraGroups = ["scanner" "lp"];
}
