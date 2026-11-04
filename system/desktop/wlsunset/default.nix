{
  config,
  pkgs,
  ...
}: {
  hjem.users.${config.my.user.name} = {
    systemd.services.wlsunset = {
      description = "Day/night gamma adjustments for Wayland compositors.";
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";

      serviceConfig.ExecStart =
        "${pkgs.wlsunset}/bin/wlsunset"
        + " -t 2000 -S 07:00 -s 21:00 -d 600";
    };
  };
}
