{
  lib,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    vt = 2;
    # Assumes that the directory containing `wayland-sessions` is first in $XDG_DATA_DIRS,
    # which seems to be true so far.
    settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session --user-menu --asterisks --sessions \${XDG_DATA_DIRS%%:*}/wayland-sessions";
  };
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Don't allow using fprintd for greetd login (first login)
  security.pam.services.greetd.rules.auth.fprintd.enable = lib.mkForce false;
}
