{config, ...}: let
  cfg = config.services.tt-rss;
  url = "http://feeds.adtailnet";
in {
  services.tt-rss = {
    enable = true;
    selfUrlPath = url;
    virtualHost = url;
  };

  my.persist.local.directories = [
    {
      directory = cfg.root;
      user = cfg.user;
      # This group is hardcoded:
      # https://github.com/NixOS/nixpkgs/blob/a79cfe0ebd24952b580b1cf08cd906354996d547/nixos/modules/services/web-apps/tt-rss.nix#L635
      group = "tt_rss";
      mode = "700";
    }
    # TODO Should this be moved elsewhere for if something else uses PostgreSQL?
    #
    # NOTE Currently nothing super important here, so putting it in local
    # instead of data. If important data is stored here in the future, either
    # migrate to data or use the `postgresqlBackup` service from nixpkgs.
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
