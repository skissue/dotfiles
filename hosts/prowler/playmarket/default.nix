{
  config,
  inputs,
  lib,
  private,
  ...
}: let
  cfg = config.services.playmarket;
  domain = "playmarket.${private.domain.wasteoftime}";
  iridescentAddresses = [
    "100.72.86.116"
    "fd7a:115c:a1e0:f811:19ba:3d4f:a16e:e3c6"
  ];
  iridescentAddressesString = lib.concatStringsSep " " iridescentAddresses;
in {
  imports = [inputs.playmarket.nixosModules.default];

  services.playmarket.enable = true;
  services.playmarket.port = 8889;

  services.caddy = {
    globalConfig = lib.mkAfter ''
      servers {
        trusted_proxies static ${iridescentAddressesString}
        trusted_proxies_strict
      }
    '';

    virtualHosts."http://${domain}".extraConfig = ''
      @not-iridescent not remote_ip ${iridescentAddressesString}
      respond @not-iridescent 403

      request_header -X-Auth-User

      encode
      reverse_proxy http://127.0.0.1:${toString cfg.port} {
        header_up X-Real-IP {client_ip}
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
