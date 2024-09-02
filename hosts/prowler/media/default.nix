{config, ...}: {
  imports = [./jellyfin.nix];

  users.groups.media = {};
  my.user.extraGroups = ["media"];

  my.persist.data.directories = [
    {
      directory = "/etc/media";
      user = config.my.user.name;
      group = "media";
      mode = "750";
    }
  ];
}
