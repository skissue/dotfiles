{
  config,
  pkgs,
  private,
  ...
}: {
  sops.secrets.tailscale-auth-key = {
    restartUnits = ["tailscaled-autoconnect.service"];
  };

  services.tailscale = {
    enable = true;
    package = pkgs.tailscale.overrideAttrs (oldAttrs: {
      patches = oldAttrs.patches or [] ++ [
        # I don't want Tailscale to swallow all DNS traffic, but I still want it
        # to accept DNS settings for MagicDNS. So, patch Tailscale to never ask
        # systemd-resolved for a `~.` domain.
        ./no-all-route.patch
        # Limit the IPv4 CGNAT range to the range that I
        # use. Specifically restricted to not interfere with the IPv4
        # CGNAT range that Mullvad uses for DNS (100.64.0.0/24).
        ./limit-ipv4-cgnat.patch
      ];

      # A lot of tests fail with a custom CGNAT range.
      doCheck = false;
    });
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    authKeyParameters = {
      ephemeral = false;
      preauthorized = true;
    };
    extraUpFlags = [
      "--login-server"
      "https://hs.${private.domain.personal}"
    ];
    extraDaemonFlags = ["--no-logs-no-support"];
  };

  my.persist.local.directories = [
    {
      directory = "/var/lib/tailscale";
      mode = "700";
    }
  ];

  # Accept all Tailscale traffic, it's trusted anyway
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
