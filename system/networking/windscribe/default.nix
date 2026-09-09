{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.windscribe.nixosModules.default];

  # Login, connection settings and the kill switch are managed by the official app.
  services.windscribe.enable = true;

  # Allow asymmetric routing through VPN tunnels.
  networking.firewall.checkReversePath = "loose";

  # Port forwarding
  networking.firewall.interfaces."utun420" = {
    allowedTCPPorts = [51966];
    allowedUDPPorts = [51966];
  };

  # Also exclude 100.72.0.0/16 and 100.100.100.100 in Windscribe's split-tunnel
  # settings so its firewall permits peers and MagicDNS. These scoped rules precede
  # Windscribe's reserved 5208/5209 rules and Tailscale's 5210+ rules.
  systemd.network.networks."10-tailscale0".routingPolicyRules = [
    {
      To = "100.72.0.0/16";
      Table = 52;
      Priority = 5100;
      Family = "ipv4";
    }
    {
      To = "100.100.100.100/32";
      Table = 52;
      Priority = 5101;
      Family = "ipv4";
    }
  ];

  # If a peer route disappears, never fall through to Windscribe's physical
  # gateway exclusion. Keep this guard outside Windscribe's managed chains.
  # Loopback remains allowed for connections to this host's own tailnet IP.
  networking.nftables.tables.windscribe-tailnet = {
    family = "inet";
    content = ''
      chain output {
        type filter hook output priority filter + 10; policy accept;
        ip daddr { 100.72.0.0/16, 100.100.100.100 } oifname != { "tailscale0", "lo" } counter drop
      }
    '';
  };

  # Windscribe configures VPN DNS without overriding resolved's global TLS policy.
  # Its tunnel DNS must not inherit the mandatory DoT setting used for Quad9.
  services.resolved.settings.Resolve.DNSOverTLS = lib.mkForce "false";
}
