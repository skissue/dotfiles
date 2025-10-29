{mkModulesList, ...}: {
  imports =
    mkModulesList [
      # "ntfy-alerts/syslog"
    ]
    ++ [
      ./headscale
      ./iodine
      ./nginx
      ./ntfy-server
    ];

  security.sudo-rs.wheelNeedsPassword = false;

  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = ["--advertise-exit-node"];
  };

  # State version (copy from auto-generated configuration.nix during install)
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11";
}
