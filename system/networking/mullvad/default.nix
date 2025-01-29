{pkgs, ...}: {
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };

  # Fix for Tailscale + Mullvad, allows all Tailscale-related traffic
  # to bypass VPN tunnel. See here for details:
  # https://mullvad.net/en/help/split-tunneling-with-linux-advanced
  # https://github.com/r3nor/mullvad-tailscale/blob/main/mullvad.rules
  networking.nftables.tables.mullvad-tailscale = {
    family = "inet";
    content = ''
      chain allowOutgoing {
        type route hook output priority 0; policy accept;
        ip  daddr 100.69.0.0/16       ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
        ip6 daddr fd7a:115c:a1e0::/48 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      chain allowDns {
        type filter hook output priority -10; policy accept;
        ip daddr 100.100.100.100 udp dport 53 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      chain allowIncoming {
        type filter hook input priority -100; policy accept;
        iifname "tailscale0" ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    '';
  };

  # For some reason (complicated routing table shenanigans), incoming Tailscale
  # packets fail the reverse path check when Mullvad is enabled. Instead of
  # disabling reverse path filtering entirely, this allows all incoming
  # Tailscale traffic to pass the reverse path chain.
  networking.firewall.extraReversePathFilterRules = ''
    iifname "tailscale0" ip saddr 100.69.0.0/16 accept;
  '';

  # Exclude Tailscale from Mullvad tunnel
  systemd.services.mullvad-exclude-tailscale = {
    wantedBy = ["multi-user.target"];
    after = ["mullvad-daemon.service" "tailscaled.service"];
    path = with pkgs; [mullvad procps];
    script = "mullvad split-tunnel add $(pidof tailscaled)";
  };
}
