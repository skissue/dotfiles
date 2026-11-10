{
  config,
  private,
  ...
}: let
  domain = "ntfy.${private.domain.internal}";
  cfg = config.services.ntfy-sh;
in {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${domain}";
      # Any unoccupied port is fine, will be reverse-proxied by Caddy.
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
    };
  };

  my.persist.local.directories = ["/var/lib/private/ntfy-sh"];

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "internal";
    extraConfig = ''
      @not-tailnet not remote_ip 100.72.0.0/16 fd7a:115c:a1e0::/48
      respond @not-tailnet 403
      reverse_proxy http://${cfg.settings.listen-http}
    '';
  };
}
