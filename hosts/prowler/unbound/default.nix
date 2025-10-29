{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.unbound;
  dataDir = cfg.stateDir;
in {
  services.unbound = {
    enable = true;
    # Only used internally within my tailnet.
    resolveLocalQueries = false;
    settings = {
      server = {
        # 5353 is already used by systemd-resolved for whatever the
        # hell mDNS is 🗿.
        interface = [
          "0.0.0.0@5354"
          "::0@5354"
        ];
        # Tailscale IPs
        access-control = [
          "100.69.0.0/16 allow"
          "fd7a:115c:a1e0::/48 allow"
        ];
      };
      remote-control.control-enable = true;

      include = [
        "${dataDir}/oisd-big-blocklist.conf"
      ];
    };
  };
  # In case this is the first run, and the files don't exist yet.
  systemd.services.unbound.preStart = ''
    touch ${dataDir}/oisd-big-blocklist.conf
  '';

  systemd.services.update-blocklists = {
    description = "Update blocklists for Unbound";
    path = with pkgs; [curl unbound];
    script = ''
      curl https://big.oisd.nl/unbound -o ${dataDir}/oisd-big-blocklist.conf
      unbound-control reload
    '';
    serviceConfig = {
      User = "unbound";
      Group = "unbound";
    };
  };
  systemd.timers.update-blocklists = {
    description = "Update blocklists every day";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      Persistent = true;
    };
  };

  my.persist.local.directories = [
    {
      directory = dataDir;
      user = cfg.user;
      group = cfg.group;
      mode = "0700";
    }
  ];

  # Since this doesn't run on port 53, DNAT all traffic from my tailnet to it.
  networking.nftables.tables.unbound-nat = {
    family = "inet";
    content = ''
      chain prerouting {
        type nat hook prerouting priority 0;
        ip  saddr 100.69.0.0/16       tcp dport 53 redirect to 5354
        ip  saddr 100.69.0.0/16       udp dport 53 redirect to 5354
        ip6 saddr fd7a:115c:a1e0::/48 tcp dport 53 redirect to 5354
        ip6 saddr fd7a:115c:a1e0::/48 udp dport 53 redirect to 5354
      }
    '';
  };
}
