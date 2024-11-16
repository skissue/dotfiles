{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
    };

    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = lib.getExe config.programs.hyprland.package;
        };
      };
    };

    # Needed for file pickers and stuff
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    # Needed for hyprlock
    security.pam.services.hyprlock = {};
  };
}
