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
        nameservers.global = [
          # prowler
          "fd7a:115c:a1e0:5e86:7755:f40d:4b4f:19ed"
          "100.72.228.191"
          # iridescent
          "fd7a:115c:a1e0:f811:19ba:3d4f:a16e:e3c6"
          "100.72.86.116"
        ];
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

  # Persist database.
  my.persist.local.directories = [
    {
      # See value of `services.headscale.settings.database.sqlite.path`. Noise
      # private key also lives here.
      directory = "/var/lib/headscale";
      user = cfg.user;
      group = cfg.group;
      mode = "750";
    }
  ];

  # DNS
  # TODO clean up
  services.headscale.settings.dns.extra_records = [
    {
      name = "media.${private.domain.private}";
      type = "A";
      value = "100.72.228.191";
    }
    {
      name = "media.${private.domain.private}";
      type = "AAAA";
      value = "fd7a:115c:a1e0:5e86:7755:f40d:4b4f:19ed";
    }
    {
      name = "feeds.${private.domain.private}";
      type = "A";
      value = "100.72.228.191";
    }
    {
      name = "feeds.${private.domain.private}";
      type = "AAAA";
      value = "fd7a:115c:a1e0:5e86:7755:f40d:4b4f:19ed";
    }
    {
      name = "oldfeeds.${private.domain.private}";
      type = "A";
      value = "100.72.228.191";
    }
    {
      name = "oldfeeds.${private.domain.private}";
      type = "AAAA";
      value = "fd7a:115c:a1e0:5e86:7755:f40d:4b4f:19ed";
    }
    {
      name = "ntfy.${private.domain.private}";
      type = "A";
      value = "100.72.86.116";
    }
    {
      name = "ntfy.${private.domain.private}";
      type = "AAAA";
      value = "fd7a:115c:a1e0:f811:19ba:3d4f:a16e:e3c6";
    }
    {
      name = "scrobbles.${private.domain.private}";
      type = "A";
      value = "100.72.228.191";
    }
    {
      name = "scrobbles.${private.domain.private}";
      type = "AAAA";
      value = "fd7a:115c:a1e0:5e86:7755:f40d:4b4f:19ed";
    }
  ];
}
