{
  pkgs,
  inputs,
  ...
}: {
  config = {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
    };

    # Needed for file pickers and stuff
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    # Needed for hyprlock
    security.pam.services.hyprlock = {};
  };
}
