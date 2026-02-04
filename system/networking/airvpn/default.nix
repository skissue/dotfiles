{
  config,
  secretsDir,
  ...
}: {
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
        FirewallMark = 22222;
      };
      wireguardPeers = [
        {
          PublicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";
          PresharedKeyFile = config.sops.secrets."airvpn/preshared".path;
          Endpoint = "america3.vpn.airdns.org:1637";
          AllowedIPs = ["0.0.0.0/0" "::/0"];
          PersistentKeepalive = 15;
          RouteTable = 222;
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
      linkConfig = {
        ActivationPolicy = "manual";
      };
      routingPolicyRules = [
        {
          Family = "both";
          FirewallMark = 22222;
          InvertRule = true;
          Table = 222;
          Priority = 50;
        }
        # Allow local private IPs outside the tunnel.
        {
          To = "10.0.0.0/8";
          Table = "main";
          Priority = 49;
        }
        {
          To = "192.168.0.0/16";
          Table = "main";
          Priority = 49;
        }
      ];
    };
  };

  # Required for Wireguard tunnels to function.
  networking.firewall.checkReversePath = "loose";
}
