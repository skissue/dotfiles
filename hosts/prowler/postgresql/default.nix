{config, ...}: {
  # TODO Is there anything important here? Should this be persisted under "data",
  # or perhaps a backup script should put data there?
  my.persist.local.directories = [
    {
      directory = config.services.postgresql.dataDir;
      # Hardcoded:
      # https://github.com/NixOS/nixpkgs/blob/64e75cd44acf21c7933d61d7721e812eac1b5a0a/nixos/modules/services/databases/postgresql.nix#L586-L593
      user = config.users.users.postgres.name;
      group = config.users.users.postgres.group;
      mode = "700";
    }
  ];
}
