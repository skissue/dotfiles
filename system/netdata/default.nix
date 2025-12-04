{
  services.netdata = {
    enable = true;
    config.global = {
      "error log" = "syslog";
      "access log" = "syslog";
      "debug log" = "off";
    };
  };
}
