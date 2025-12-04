{pkgs, ...}: {
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
  };
}
