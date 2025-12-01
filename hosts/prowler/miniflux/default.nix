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
      HTTPS = 1;

      # SSO via Kanidm. Secret is set in the adminCredentialsFile.
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_OIDC_PROVIDER_NAME = "Kanidm";
      OAUTH2_CLIENT_ID = "miniflux";
      OAUTH2_REDIRECT_URL = "https://${domain}/oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.${private.domain.private}/oauth2/openid/miniflux";
      OAUTH2_USER_CREATION = 1;
      DISABLE_LOCAL_AUTH = 1;

      CLEANUP_ARCHIVE_READ_DAYS = 365;
      CLEANUP_ARCHIVE_UNREAD_DAYS = -1;
      FETCH_YOUTUBE_WATCH_TIME = 1;
    };
  };

  # Being owned by root is fine.
  sops.secrets.miniflux-config = {};

  security.acme.certs.feeds.domain = domain;

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "feeds";
    extraConfig = ''
      reverse_proxy http://${cfg.config.LISTEN_ADDR}
    '';
  };
}
