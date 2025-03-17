{config, ...}: let
  user = config.users.users.${config.my.user.name};
in {
  # Data here (presumably) gets backed up from other places, so leave it in
  # local.
  my.persist.local.directories = [
    {
      directory = "/etc/theuniverse";
      user = user.name;
      group = user.group;
      mode = "700";
    }
  ];
}
