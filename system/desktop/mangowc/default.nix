{config,lib,inputs, ...}: {
  imports = [inputs.mangowc.nixosModules.mango];

  config = {
    programs.mango.enable = true;

    programs.dconf.enable = true;

    # Needed for hyprlock
    security.pam.services.hyprlock = {};

    # For systemd-based session management.
    programs.uwsm = {
      enable = true;
      waylandCompositors.mango = {
        prettyName = "Mango";
        comment = "Mango compositor managed by uwsm";
        binPath = lib.getExe config.programs.mango.package;
      };
    };
  };
}
