{
  pkgs,
  private,
  ...
}: {
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
}
