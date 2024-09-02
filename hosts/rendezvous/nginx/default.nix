{private, ...}: {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@${private.domain.personal}";
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
