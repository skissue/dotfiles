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

  # Keep 100.72.0.0/16 and 100.100.100.100 excluded in Windscribe's split-tunnel
  # settings. Windscribe's destination jumps let Tailscale's normal policy route
  # them, while its firewall exclusions permit peers and MagicDNS.
  # If a peer route disappears, never let these destinations use another egress.
  # Keep this guard outside Windscribe's managed chains.
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
