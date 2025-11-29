{
  config,
  private,
  ...
}: let
  # Hardcoded user:
  # https://github.com/NixOS/nixpkgs/blob/5e2a59a5b1a82f89f2c7e598302a9cacebb72a67/nixos/modules/security/acme/default.nix#L12
  acmeUser = config.users.users.acme;
in {
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;
  };

  sops.secrets.porkbun-api-env = {
    owner = acmeUser.name;
    group = acmeUser.group;
  };
  security.acme = {
    acceptTerms = true;
    defaults.group = "nginx";
    certs.tailnet = {
      domain = private.domain.private;
      email = "acme@${private.domain.personal}";
      extraDomainNames = ["*.${private.domain.private}"];
      dnsProvider = "porkbun";
      environmentFile = config.sops.secrets.porkbun-api-env.path;
    };
  };

  my.persist.local.directories = [
    {
      directory = "/var/lib/acme";
      user = acmeUser.name;
      group = acmeUser.group;
      mode = "755";
    }
  ];
}
