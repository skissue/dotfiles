{
  config,
  private,
  ...
}: let
  domain = "ntfy.${private.domain.private}";
  cfg = config.services.ntfy-sh;
in {
  security.acme.certs.ntfy.domain = domain;

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${domain}";
      # Any unoccupied port is fine, will be reverse-proxied by Caddy.
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
    };
  };

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "ntfy";
    extraConfig = ''
      @not-tailnet not remote_ip 100.72.0.0/16 fd7a:115c:a1e0::/48
      respond @not-tailnet 403
      reverse_proxy http://${cfg.settings.listen-http}
    '';
  };
}
