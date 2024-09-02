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
      patches = [
        # I don't want Tailscale to swallow all DNS traffic, but I want
        # to keep `override_local_dns` on for mobile devices. So, patch
        # Tailscale to never ask systemd-resolved for a `~.` domain.
        ./no-all-route.patch
        # Limit the IPv4 CGNAT range to the range that I
        # use. Specifically restricted to not interfere with the IPv4
        # CGNAT range that Mullvad uses for DNS (100.64.0.0/24).
        ./limit-ipv4-cgnat.patch
        # Horrendous, horrible, hardcoded hack to request the base server domain
        # as a DNS search domain with systemd-resolved. This isn't usually
        # necessary, since Tailscale requests the root domain already, but since
        # we patch it to *not* do that, we need to request the server's domain
        # instead, else addresses like `media.adtailnet` won't resolve.
        ./request-base-dns-domain.patch
      ];
    });
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    extraUpFlags = [
      "--login-server"
      "https://hs.${private.domain.personal}"
    ];
  };
  # Don't send traffic logs to Tailscale. I don't want your support, Tailscale.
  # I'm not even using your coordination servers.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_NO_LOGS_NO_SUPPORT=true"
  ];

  my.persist.local.directories = [
    {
      directory = "/var/lib/tailscale";
      mode = "700";
    }
  ];

  # Accept all Tailscale traffic, it's trusted anyway
  networking.firewall.trustedInterfaces = ["tailscale0"];
}
