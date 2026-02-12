{
  config,
  secretsDir,
  ...
}:
with import ./values.nix; let
  wgTable = 222;
in {
  imports = [./exclude.nix];

  sops.secrets."airvpn/private" = {
    sopsFile = "${secretsDir}/desktop.yaml";
    owner = "systemd-network";
  };
  sops.secrets."airvpn/preshared" = {
    sopsFile = "${secretsDir}/desktop.yaml";
    owner = "systemd-network";
  };

  systemd.network = {
    netdevs.${netconfName} = {
      netdevConfig = {
        Name = "wg0";
        Kind = "wireguard";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."airvpn/private".path;
        FirewallMark = wgMark;
      };
      wireguardPeers = [
        {
          PublicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          PresharedKeyFile = config.sops.secrets."airvpn/preshared".path;
          Endpoint = "us3.vpn.airdns.org:1637";
          AllowedIPs = ["0.0.0.0/0" "::/0"];
          PersistentKeepalive = 15;
          RouteTable = wgTable;
        }
      ];
    };

    networks.${netconfName} = {
      matchConfig.Name = "wg0";
      networkConfig = {
        Address = ["10.182.62.103/32" "fd7d:76ee:e68f:a993:7ecd:ccf1:f6b0:7754/128"];
        DNS = ["10.128.0.1" "fd7d:76ee:e68f:a993::1"];
        DNSDefaultRoute = true;
        Domains = ["~."];
        DNSOverTLS = false;
      };
      routingPolicyRules = [
        # Try Tailscale's routing table first. Tailscale only adds entries for
        # its IPs, so this sends Tailscale traffic to Tailscale and other
        # traffic will fallback.
        #
        # NOTE: Tailscale will always use routing table 52:
        # https://github.com/tailscale/tailscale/blob/5edfa6f9a8b409908861172882de03e9a67f0c2f/wgengine/router/osrouter/router_linux.go#L1208-L1224
        {
          Family = "both";
          Priority = wgPriority - 10;
          Table = 52;
        }
        {
          Family = "both";
          FirewallMark = wgMark;
          InvertRule = true;
          Table = wgTable;
          Priority = wgPriority;
        }
      ];
    };
  };

  # Required for Wireguard tunnels to function.
  networking.firewall.checkReversePath = "loose";

  # HACK To resolve the domain used for the endpoint (*.vpn.airdns.org), we need a
  # link that explicitly handles the route as otherwise resolved will attempt to
  # route to wg0 (since it has ~.), which obviously fails since the link is not
  # up yet.
  services.resolved.settings.Resolve.Domains = "~vpn.airdns.org";
}
