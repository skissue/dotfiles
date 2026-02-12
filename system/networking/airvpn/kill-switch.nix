with import ./values.nix; {
  networking.nftables.tables.airvpn-kill-switch = {
    family = "inet";
    content = ''
      chain output {
        type filter hook output priority filter; policy drop;

        oifname "lo"              accept
        oifname "wg0"             accept
        oifname "tailscale0"      accept
        meta mark ${wgMarkS}      accept
        meta mark ${excludeMarkS} accept
      }

      chain input {
        type filter hook input priority filter; policy drop;

        ct state {established, related} accept
        iifname "lo"                    accept
        iifname "wg0"                   accept
        iifname "tailscale0"            accept
      }
    '';
  };
}
