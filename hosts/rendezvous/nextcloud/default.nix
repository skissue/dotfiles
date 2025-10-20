{
  config,
  pkgs,
  private,
  ...
}: {
  sops.secrets.nextcloud-s3-secret = let
    user = config.users.users.nextcloud;
  in {
    owner = user.name;
    group = user.group;
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    https = true;
    hostName = "cloud.${private.domain.personal}";

    database.createLocally = true;
    config = {
      objectstore.s3 = {
        enable = true;
        hostname = "ewr1.vultrobjects.com";
        key = "PV0HM55ALC4XZPDI1336";
        secretFile = config.sops.secrets.nextcloud-s3-secret.path;
        # Name has to be unique
        bucket = "nextcloud-6969";
        autocreate = true;
      };

      dbtype = "mysql";
      adminpassFile = toString (pkgs.writeText "adminpass" "root");
    };
    phpOptions = {
      "opcache.interned_strings_buffer" = "12";
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    useACMEHost = "personal";
  };
}
