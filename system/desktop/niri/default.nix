{
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

    # Fallback portal, after GNOME's
    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];

    # Needed for hyprlock
    security.pam.services.hyprlock = {};

    # Enabled by the module by default, but conflicts with KeePassXC.
    services.gnome.gnome-keyring.enable = lib.mkForce false;
  };
}
