{
  config,
  pkgs,
  private,
  ...
}: let
  domain = "auth.${private.domain.private}";
  certDir = config.security.acme.certs.kanidm.directory;
in {
  # HTTPS certificate.
  security.acme.certs.kanidm.domain = domain;

  services.kanidm = {
    package = pkgs.kanidm_1_8;

    enableServer = true;
    serverSettings = {
      inherit domain;
      origin = "https://${domain}";
      tls_chain = "${certDir}/fullchain.pem";
      tls_key = "${certDir}/key.pem";
    };
  };

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
