{
  config,
  pkgs,
  private,
  ...
}: let
  domain = private.domain.tailnet';
in {
  sops.secrets.tailscale-auth-key = {
    restartUnits = ["tailscaled-autoconnect.service"];
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    extraDaemonFlags = ["--no-logs-no-support"];
    extraUpFlags = [
      "--login-server"
      "https://${domain}"
    ];
    extraSetFlags = [
      "--operator"
      config.my.user.name
      "--accept-routes"
    ];
  };

  my.persist.local.directories = [
    {
      directory = "/var/lib/tailscale";
      mode = "700";
    }
  ];

  # Accept all Tailscale traffic, it's trusted anyway
  networking.firewall.trustedInterfaces = ["tailscale0"];

  systemd.network.networks."10-tailscale0" = {
    matchConfig.Name = "tailscale0";
    linkConfig.RequiredForOnline = false;

    networkConfig = {
      Domains = ["in.${domain}" "~${private.domain.private}"];
      DNS = "100.100.100.100";
      DNSOverTLS = false;
      LLMNR = false;

      # networkd goes on strike without this.
      ConfigureWithoutCarrier = true;
      KeepConfiguration = true;
      LinkLocalAddressing = false;
    };
  };
}
