with import ./values.nix; {
  systemd.network.networks.${netconfName}.routingPolicyRules = [
    {
      Family = "both";
      FirewallMark = excludeMark;
      Priority = wgPriority - 1;
      Table = "main";
    }
  ];

  systemd.slices.system-airvpn_exclude = {
    description = "Slice for processes to exclude from AirVPN tunnel";
    wantedBy = ["multi-user.target"];
    before = ["nftables.service"];
  };

  networking.nftables.tables.airvpn-exclude = {
    family = "inet";
    content = ''
      chain output {
        type route hook output priority mangle;

        # Ignore non-wg0 traffic.
        oifname != "wg0" accept

        # Allow local private IPs outside the tunnel.
        ip daddr 10.0.0.0/24    meta mark set ${excludeMarkS}
        ip daddr 192.168.0.0/16 meta mark set ${excludeMarkS}

        # HACK Send Quad9 traffic outside the tunnel to resolve the initial
        # *.vpn.airdns.org endpoint domain (see above). Must match a server in
        # networking.nameservers
        ip daddr 9.9.9.9 tcp dport 853 meta mark set ${excludeMarkS}

        socket cgroupv2 level 2 "system.slice/system-airvpn_exclude.slice" meta mark set ${excludeMarkS}
      }

      chain postrouting {
        type nat hook postrouting priority srcnat;
        meta mark ${excludeMarkS} masquerade
      }
    '';
  };

  # Cgroup path doesn't exist in build sandbox, skip validation.
  networking.nftables.checkRuleset = false;

  # Exclude Tailscale traffic from the Wireguard tunnel by putting it into the
  # slice.
  systemd.services.tailscaled.serviceConfig.Slice = "system-airvpn_exclude.slice";
}
