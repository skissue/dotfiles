{...}: {
  imports = [./jellyfin.nix];

  users.groups.media = {};
  my.user.extraGroups = ["media"];

  systemd.tmpfiles.rules = [
    "L+ /etc/media - - - - /etc/theuniverse/libraries"
  ];
}
