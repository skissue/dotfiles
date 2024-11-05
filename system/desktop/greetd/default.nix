{
  lib,
  pkgs,
  ...
}: let
  nwg-hello-hyprland-conf = pkgs.writeText "nwg-hello-hyprland-conf" ''
    monitor = ,preferred,auto,1
    bind = SUPER,Q,killactive
    misc {
        disable_hyprland_logo = true
    }
    animations {
        enabled = false
    }
    exec-once = ${lib.getExe pkgs.nwg-hello}; hyprctl dispatch exit
  '';
in {
  services.greetd = {
    enable = true;
    vt = 2;
    settings.default_session.command = "Hyprland -c ${nwg-hello-hyprland-conf}";
  };

  security.pam.services.greetd.enableGnomeKeyring = true;

  environment.pathsToLink = ["/share/wayland-sessions"];
}
