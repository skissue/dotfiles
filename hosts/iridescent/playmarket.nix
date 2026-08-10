{
  config,
  pkgs,
  private,
  ...
}: let
  domain = "playmarket.${private.domain.wasteoftime}";
  origin = "prowler.in.${private.domain.tailnet'}";
  anubisCfg = config.services.anubis.instances.playmarket;
in {
  security.acme.certs.wasteoftime.domain = "*.${private.domain.wasteoftime}";

  services.anubis.instances.playmarket = {
    policy = {
      useDefaultBotRules = false;
      extraBots = [
        {
          name = "declared-bots";
          user_agent_regex = "(?i:bot|crawler|spider|slurp|archiver)";
          action = "DENY";
        }
        {
          name = "challenge-everyone";
          path_regex = ".*";
          action = "CHALLENGE";
        }
      ];
    };
    settings = {
      TARGET = "http://${origin}";
      COOKIE_HTTP_ONLY = true;
      REDIRECT_DOMAINS = domain;
    };
  };

  services.caddy = {
    package = pkgs.caddy.withPlugins {
      plugins = ["github.com/mholt/caddy-ratelimit@v0.1.1-0.20260612195517-5625512f24f6"];
      hash = "sha256-y+lf699YUSBwMmq62K7NKSRzjS849xRdWATJJrUdIOI=";
    };

    virtualHosts.${domain} = {
      useACMEHost = "wasteoftime";
      extraConfig = ''
        header {
          X-Content-Type-Options nosniff
          X-Frame-Options DENY
          Referrer-Policy same-origin
          X-Robots-Tag "noindex, nofollow, noarchive, nosnippet, noimageindex"
        }

        route {
          @robots path /robots.txt
          header @robots Content-Type "text/plain; charset=utf-8"
          respond @robots <<ROBOTS
            User-agent: *
            Disallow: /

            ROBOTS 200

          rate_limit {
            zone playmarket-login {
              match {
                path /login
                method POST
              }
              key {remote_host}
              events 5
              window 1m
              ipv6_prefix 64
            }
            zone playmarket-general {
              key {remote_host}
              events 300
              window 1m
              ipv6_prefix 64
            }
          }

          reverse_proxy unix/${anubisCfg.settings.BIND} {
            header_up -Forwarded
            header_up X-Real-Ip {remote_host}
            header_up X-Http-Version {http.request.proto}
          }
        }
      '';
    };
  };

  systemd.services.caddy = {
    after = ["anubis-playmarket.service"];
    wants = ["anubis-playmarket.service"];
    serviceConfig.SupplementaryGroups = [anubisCfg.group];
  };
}
