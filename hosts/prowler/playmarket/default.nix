{
  config,
  inputs,
  private,
  ...
}: let
  cfg = config.services.playmarket;
  auth = config.services.tailscaleAuth;
  domain = "playmarket.${private.domain.wasteoftime}";
in {
  imports = [inputs.playmarket.nixosModules.default];

  services.playmarket.enable = true;
  services.playmarket.port = 8889;

  services.tailscaleAuth.enable = true;
  users.users.${config.services.caddy.user}.extraGroups = [auth.group];

  security.acme.certs.wasteoftime.domain = "*.${private.domain.wasteoftime}";

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "wasteoftime";
    extraConfig = ''
      route {
        request_header -X-Auth-User

        forward_auth unix/${auth.socketPath} {
          uri /auth
          header_up Remote-Addr {remote_host}
          header_up Remote-Port {remote_port}
          header_up Original-URI {uri}
          copy_headers {
            Tailscale-User>X-Auth-User
          }
        }

        reverse_proxy http://127.0.0.1:${toString cfg.port}
      }
    '';
  };

  # DynamicUser places StateDirectory beneath /var/lib/private and exposes it
  # to the service at /var/lib/playmarket.
  systemd.services.playmarket.serviceConfig.StateDirectoryMode = "0700";
  my.persist.data.directories = [
    {
      directory = "/var/lib/private/playmarket";
      mode = "700";
    }
  ];
}
