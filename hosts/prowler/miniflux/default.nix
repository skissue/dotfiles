{
  config,
  private,
  ...
}: let
  cfg = config.services.miniflux;
  domain = "feeds.${private.domain.private}";
in {
  services.miniflux = {
    enable = true;
    createDatabaseLocally = true;

    # Despite the name, any configuration can go here, since it's simply passed
    # into systemd's EnvironmentFile. Since it's handled directly by systemd, it
    # can be owned by root.
    adminCredentialsFile = config.sops.secrets.miniflux-config.path;
    config = {
      BASE_URL = "https://${domain}";
    };
  };

  # Being owned by root is fine.
  sops.secrets.miniflux-config = {};

  security.acme.certs.feeds.domain = domain;

  services.nginx.virtualHosts.${domain} = {
    addSSL = true;
    useACMEHost = "feeds";
    locations."/" = {
      proxyPass = "http://${cfg.config.LISTEN_ADDR}";
    };
  };
}
