{
  config,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    vt = 2;
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --user-menu --asterisks --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
}
