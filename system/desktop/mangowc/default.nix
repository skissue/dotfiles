{
  inputs,
  ...
}: {
  imports = [inputs.mangowc.nixosModules.mango];

  config = {
    programs.mango.enable = true;

    # Needed for hyprlock
    security.pam.services.hyprlock = {};
  };
}
