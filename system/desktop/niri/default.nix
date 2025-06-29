{
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

    # Needed for hyprlock
    security.pam.services.hyprlock = {};
  };
}
