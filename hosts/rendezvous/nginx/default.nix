{
  config,
  private,
  ...
}: let
  domain = private.domain.personal;
in {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };

  sops.secrets.porkbun-api-env = let
    # Hardcoded user.
    user = config.users.users.acme;
  in {
    owner = user.name;
    group = user.group;
  };
  security.acme = {
    acceptTerms = true;
    defaults.group = "nginx";
    certs.personal = {
      inherit domain;
      email = "acme@${domain}";
      extraDomainNames = ["*.${domain}"];
      dnsProvider = "porkbun";
      environmentFile = config.sops.secrets.porkbun-api-env.path;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];
}
