{
  lib,
  pkgs,
  ...
}: {
  systemd.services.ntfy-journal = {
    description = "Notify on errors from syslog";
    wantedBy = ["multi-user.target"];
    after = ["systemd-journald.service" "network-online.target"];
    script = "exec ${lib.getExe pkgs.nushell} ${./script.nu}";
  };
}
