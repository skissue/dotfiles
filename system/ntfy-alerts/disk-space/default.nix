{
  lib,
  pkgs,
  ...
}: {
  systemd.services.disk-usage-alert = {
    description = "Notify when disk usage is above 90%";
    path = with pkgs; [nettools]; # for `hostname`
    script = "${lib.getExe pkgs.nushell} ${./script.nu}";
  };
  systemd.timers.disk-usage-alert = {
    description = "Check disk usage every hour";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnActiveSec = "0";
      OnUnitActiveSec = "1h";
    };
  };
}
