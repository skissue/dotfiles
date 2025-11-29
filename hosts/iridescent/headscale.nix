{
  config,
  pkgs,
  private,
  ...
}: let
  cfg = config.services.headscale;
  domain = private.domain.tailnet';
in {
  services.headscale = {
    enable = true;
    settings = {
      server_url = "https://${domain}";

      prefixes = {
        v4 = "100.72.0.0/16";
        v6 = "fd7a:115c:a1e0::/48";
        allocation = "random";
      };

      dns = {
        magic_dns = true;
        base_domain = "in.${domain}";
        override_local_dns = true;
        nameservers.global = ["9.9.9.9" "149.112.112.112" "2620:fe::fe" "2620:fe::9"];
      };

      # OIDC authentication via kanidm.
      oidc = {
        only_start_if_oidc_is_available = true;
        issuer = "https://auth.${private.domain.private}/oauth2/openid/headscale";
        client_id = "headscale";
        client_secret_path = config.sops.secrets.headscale-oidc-secret.path;
        pkce.enabled = true;
      };
    };
  };

  # OIDC secret (from kanidm).
  sops.secrets.headscale-oidc-secret = {
    owner = cfg.user;
    group = cfg.group;
  };

  # Access to administratation tools.
  environment.systemPackages = [pkgs.headscale];

  # Let Caddy automatically get the HTTPS certificate.
  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:${toString cfg.port}
    '';
  };
}
