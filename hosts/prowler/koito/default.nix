{
  config,
  private,
  ...
}: let
  domain = "scrobbles.${private.domain.internal}";
in {
  services.koito.enable = true;

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "internal";
    extraConfig = ''
      reverse_proxy http://127.0.0.1:${toString config.services.koito.environment.KOITO_LISTEN_PORT}
    '';
  };

  # DynamicUser places StateDirectory beneath /var/lib/private and exposes it
  # to the service at /var/lib/koito.
  systemd.services.koito.serviceConfig.StateDirectoryMode = "0700";
  my.persist.local.directories = [
    {
      directory = "/var/lib/private/koito";
      mode = "700";
    }
  ];
}
