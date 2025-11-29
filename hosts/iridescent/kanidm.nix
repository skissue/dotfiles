{
  config,
  pkgs,
  private,
  ...
}: let
  domain = "auth.${private.domain.private}";
  certDir = config.security.acme.certs.kanidm.directory;
  # Hardcoded user.
  user = config.users.users.kanidm;
in {
  # HTTPS certificate.
  security.acme.certs.kanidm = {
    domain = domain;
    # Allow kanidm service to read the certificates it needs.
    postRun = ''
      ${pkgs.acl}/bin/setfacl -m u:${user.name}:rx ${certDir}
      ${pkgs.acl}/bin/setfacl -m u:${user.name}:r  ${certDir}/{fullchain,key}.pem
    '';
    # Reload kanidm and Caddy when certificates are updated.
    reloadServices = ["kanidm" "caddy"];
  };

  services.kanidm = {
    package = pkgs.kanidm_1_8;

    enableServer = true;
    serverSettings = {
      version = "2";

      inherit domain;
      origin = "https://${domain}";
      tls_chain = "${certDir}/fullchain.pem";
      tls_key = "${certDir}/key.pem";

      # Trust X-Forwarded-For from Caddy (localhost).
      http_client_address_info.x-forward-for = ["127.0.0.1"];
    };
  };

  # Ensure HTTPS certificates exist before starting.
  systemd.services.kanidm = {
    requires = ["acme-order-renew-kanidm.service"];
    after = ["acme-order-renew-kanidm.service"];
  };

  # Hardcoded data directory (services.kanidm.serverSettings.db_path is
  # read-only).
  my.persist.data.directories = [
    {
      directory = "/var/lib/kanidm";
      user = user.name;
      group = user.group;
      mode = "700";
    }
  ];

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "kanidm";
    extraConfig = ''
      reverse_proxy https://${config.services.kanidm.serverSettings.bindaddress} {
        # Use correct domain during TLS verification. Fails otherwise since the
        # given upstream is an IP.
        transport http {
          tls_server_name ${domain}
        }
      }
    '';
  };
}
