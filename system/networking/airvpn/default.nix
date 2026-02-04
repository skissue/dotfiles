{
  config,
  secretsDir,
  ...
}: let
  wgTable = 222;
  bypassMark = 22222;
in {
  sops.secrets."airvpn/private" = {
    sopsFile = "${secretsDir}/desktop.yaml";
    owner = "systemd-network";
  };
  sops.secrets."airvpn/preshared" = {
    sopsFile = "${secretsDir}/desktop.yaml";
    owner = "systemd-network";
  };

  systemd.network = {
    netdevs."99-wg0" = {
      netdevConfig = {
        Name = "wg0";
        Kind = "wireguard";
      };
      wireguardConfig = {
        PrivateKeyFile = config.sops.secrets."airvpn/private".path;
        FirewallMark = bypassMark;
      };
      wireguardPeers = [
        {
          PublicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          PresharedKeyFile = config.sops.secrets."airvpn/preshared".path;
          Endpoint = "america3.vpn.airdns.org:1637";
          AllowedIPs = ["0.0.0.0/0" "::/0"];
          PersistentKeepalive = 15;
          RouteTable = wgTable;
        }
      ];
    };

    networks."99-wg0" = {
      matchConfig = {
        Name = "wg0";
      };
      networkConfig = {
        Address = ["10.182.62.103/32" "fd7d:76ee:e68f:a993:7ecd:ccf1:f6b0:7754/128"];
        DNS = ["10.128.0.1" "fd7d:76ee:e68f:a993::1"];
        DNSDefaultRoute = true;
        Domains = ["~."];
        DNSOverTLS = false;
      };
      routingPolicyRules = [
        {
          Family = "both";
          FirewallMark = bypassMark;
          InvertRule = true;
          Table = wgTable;
          Priority = 50;
        }
        # Allow local private IPs outside the tunnel.
        {
          To = "10.0.0.0/24";
          Table = "main";
          Priority = 49;
        }
        {
          To = "192.168.0.0/16";
          Table = "main";
          Priority = 49;
        }
        # Send Tailscale traffic to Tailscale's routing table. Subnets are taken
        # from my Headscale configuration. Could also be implemented using
        # nftables and the firewall mark from above.
        #
        # NOTE: Tailscale will always use routing table 52:
        # https://github.com/tailscale/tailscale/blob/5edfa6f9a8b409908861172882de03e9a67f0c2f/wgengine/router/osrouter/router_linux.go#L1208-L1224
        {
          To = "100.72.0.0/16";
          Table = 52;
          Priority = 49;
        }
        {
          To = "fd7a:115c:a1e0::/48";
          Table = 52;
          Priority = 49;
        }
        # HACK Send Quad9 traffic outside the tunnel to resolve the initial
        # *.vpn.airdns.org endpoint domain (see below). Must match a server in
        # networking.nameservers
        {
          To = "9.9.9.9";
          DestinationPort = 853;
          IPProtocol = "tcp";
          Table = "main";
          Priority = 49;
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
