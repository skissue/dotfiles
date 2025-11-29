{
  config,
  private,
  ...
}: let
  domain = private.domain.private;
  # Hardcoded user.
  user = config.users.users.acme;
in {
  sops.secrets.porkbun-api-env = {
    owner = user.name;
    group = user.group;
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      dnsProvider = "porkbun";
      environmentFile = config.sops.secrets.porkbun-api-env.path;
      email = private.email.personal;
    };
  };

  my.persist.local.directories = [
    {
      # Hardcoded data + certificate directory.
      directory = "/var/lib/acme";
      user = user.name;
      group = user.group;
      mode = "755";
    }
  ];
}
