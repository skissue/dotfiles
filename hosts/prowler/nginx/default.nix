{
  config,
  private,
  ...
}: {
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
    certs.tailnet = {
      domain = private.domain.tailnet;
      email = "acme@${private.domain.personal}";
      extraDomainNames = ["*.${private.domain.tailnet}"];
      dnsProvider = "porkbun";
      environmentFile = config.sops.secrets.porkbun-api-env.path;
    };
  };
}
