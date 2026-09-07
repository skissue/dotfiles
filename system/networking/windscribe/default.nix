{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.windscribe-nix.nixosModules.default];

  # Login, connection settings and the kill switch are managed by the official app.
  services.windscribe = {
    enable = true;
    package = inputs.windscribe-nix.packages.${pkgs.stdenv.hostPlatform.system}.windscribe.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          # MagicDNS is served locally by tailscaled, not an external DNS server.
          # The nftables guard below confines this exemption to tailscale0/lo.
          substituteInPlace "$out/opt/windscribe/scripts/dns-leak-protect" \
            --replace-fail 'allowed=("$@")' 'allowed=("$@" "100.100.100.100")'
        '';
    });
  };

  # Allow asymmetric routing through VPN tunnels.
  networking.firewall.checkReversePath = "loose";

  # Port forwarding
  networking.firewall.interfaces."utun420" = {
    allowedTCPPorts = [51966];
    allowedUDPPorts = [51966];
  };

  # Also exclude 100.72.0.0/16 and 100.100.100.100 in Windscribe's split-tunnel
  # settings so its firewall permits peers and MagicDNS. Priority 0 follows the existing
  # local lookup and precedes Windscribe's subsequently auto-prioritized rules.
  # Equal-priority rules retain insertion order, so re-adding this rule while
  # Windscribe has priority-0 rules installed requires checking their order.
  systemd.network.networks."10-tailscale0".routingPolicyRules = [
    {
      To = "100.72.0.0/16";
      Table = 52;
      Priority = 0;
      Family = "ipv4";
    }
    {
      To = "100.100.100.100/32";
      Table = 52;
      Priority = 0;
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
