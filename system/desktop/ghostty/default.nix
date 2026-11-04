{
  config,
  pkgs,
  mutable-link,
  ...
}: let
  ghostty = pkgs.ghostty;
in {
  users.users.${config.my.user.name}.packages = [ghostty];

  hjem.users.${config.my.user.name} = {
    xdg.config.files = {
      "ghostty".source = mutable-link ./config;

      # Register the upstream unit for on-demand D-Bus activation.
      "systemd/user/app-com.mitchellh.ghostty.service".source = "${ghostty}/share/systemd/user/app-com.mitchellh.ghostty.service";
    };

    xdg.data.files."dbus-1/services/com.mitchellh.ghostty.service".source = "${ghostty}/share/dbus-1/services/com.mitchellh.ghostty.service";
  };
}
