{
  config,
  inputs,
  private,
  ...
}: let
  domain = "scrobbles.${private.domain.private}";
in {
  imports = [inputs.koito.nixosModules.default];

  nixpkgs.overlays = [inputs.koito.overlays.default];

  services.koito = {
    enable = true;
    bindAddress = "0.0.0.0";
    allowedHosts = [domain];
  };

  security.acme.certs.scrobbles.domain = domain;

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "scrobbles";
    extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.koito.port}
    '';
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
