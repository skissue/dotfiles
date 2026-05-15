{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.niri.nixosModules.niri];

  config = {
    nixpkgs.overlays = [inputs.niri.overlays.niri];

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    # Show niri in greetd/display manager sessions
    environment.pathsToLink = ["/share/wayland-sessions"];
    services.displayManager.sessionPackages = [config.programs.niri.package];

    # Fallback portal, after GNOME's
    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

    # Needed for hyprlock
    security.pam.services.hyprlock = {};

    # Enabled by the module by default, but conflicts with KeePassXC.
    services.gnome.gnome-keyring.enable = lib.mkForce false;

    # Bundled by niri-flake; replaced with hyprpolkitagent below.
    systemd.user.services.niri-flake-polkit.enable = lib.mkForce false;
    systemd.user.services.hyprpolkitagent = {
      description = "Hyprland Polkit Authentication Agent";
      wantedBy = ["niri.service"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Slice = "session.slice";
        Restart = "on-failure";
        TimeoutStopSec = 5;
      };
    };

    # Basically Just Better™, also used by UWSM.
    services.dbus.implementation = "broker";
  };
}
