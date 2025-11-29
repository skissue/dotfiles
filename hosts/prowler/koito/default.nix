{
  config,
  inputs,
  private,
  ...
}: let
  domain = "scrobbles.${private.domain.tailnet}";
in {
  imports = [inputs.koito.nixosModules.default];

  nixpkgs.overlays = [inputs.koito.overlays.default];

  services.koito = {
    enable = true;
    bindAddress = "0.0.0.0";
    allowedHosts = [domain];
  };

  security.acme.certs.scrobbles.domain = domain;

  services.nginx.virtualHosts.${domain} = {
    addSSL = true;
    useACMEHost = "scrobbles";
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.koito.port}";
      proxyWebsockets = true;
    };
  };

  my.persist.local.directories = [
    {
      directory = "/var/lib/koito";
      user = "koito";
      group = "koito";
      mode = "700";
    }
  ];
}
