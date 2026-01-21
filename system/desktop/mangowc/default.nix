{
  inputs,
  ...
}: {
  imports = [inputs.mangowc.nixosModules.mango];

  config = {
    programs.mango.enable = true;

    programs.dconf.enable = true;

    # Needed for hyprlock
    security.pam.services.hyprlock = {};
  };
}
