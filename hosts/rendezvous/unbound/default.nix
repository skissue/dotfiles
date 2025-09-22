{
  config,
  pkgs,
  ...
}: let
  dataDir = config.services.unbound.stateDir;
in {
  # Conflict on 0.0.0.0:53
  services.resolved.enable = false;

  services.unbound = {
    enable = true;
    resolveLocalQueries = false; # Only need for Headscale
    settings = {
      server = {
        interface = ["0.0.0.0" "::0"];
        # Tailscale IPs
        access-control = [
          "100.64.0.0/10 allow"
          "fd7a:115c:a1e0::/48 allow"
        ];
      };
      remote-control.control-enable = true;

      include = [
        "${dataDir}/oisd-big-blocklist.conf"
        "${dataDir}/energized-social-blocklist.conf"
        "${dataDir}/energized-extreme-blocklist.conf"
      ];
    };
  };
  # In case this is the first run, and the files don't exist yet
  # (cannot run the update first, since, well, it needs Unbound to
  # resolve the domains)
  systemd.services.unbound.preStart = ''
    touch ${dataDir}/oisd-big-blocklist.conf
    touch ${dataDir}/energized-social-blocklist.conf
    touch ${dataDir}/energized-extreme-blocklist.conf
  '';

  systemd.services.update-blocklists = {
    description = "Update blocklists for Unbound";
    path = with pkgs; [curl unbound];
    script = ''
      curl https://big.oisd.nl/unbound -o ${dataDir}/oisd-big-blocklist.conf
      curl https://energized.pro/social/unbound.txt -o ${dataDir}/energized-social-blocklist.conf
      curl https://energized.pro/extreme/unbound.txt -o ${dataDir}/energized-extreme-blocklist.conf
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
}
