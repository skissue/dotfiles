{
  config,
  pkgs,
  private,
  ...
}: let
  cfg = config.services.netdata;
in {
  services.netdata = {
    enable = true;
    package = pkgs.netdata.override {
      withCloudUi = true;
    };

    config.global = {
      "error log" = "syslog";
      "access log" = "syslog";
      "debug log" = "off";
    };

    configDir."health_alarm_notify.conf" = pkgs.writeText "health_alarm_notify.conf" ''
      SEND_NTFY="YES"
      DEFAULT_RECIPIENT_NTFY="https://ntfy.${private.domain.private}/alerts"
    '';
  };

  # Both of these directories are managed by systemd and thus always in the same
  # place. Netdata stores the actual data in the cache directory.
  my.persist.local.directories = [
    {
      directory = "/var/lib/netdata";
      user = cfg.user;
      group = cfg.group;
      mode = "750";
    }
    {
      directory = "/var/cache/netdata";
      user = cfg.user;
      group = cfg.group;
      mode = "750";
    }
  ];
}
