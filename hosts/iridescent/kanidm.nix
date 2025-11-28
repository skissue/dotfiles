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
}
