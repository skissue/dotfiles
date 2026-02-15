{
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings.default_session.command = "${lib.getExe pkgs.tuigreet} --time --remember --remember-user-session --user-menu --asterisks --sessions /run/current-system/sw/share/wayland-sessions";
  };
}
