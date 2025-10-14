{
  config,
  inputs,
  ...
}: {
  imports = [inputs.koito.nixosModules.default];

  nixpkgs.overlays = [inputs.koito.overlays.default];

  services.koito = {
    enable = true;
    bindAddress = "0.0.0.0";
    allowedHosts = ["scrobbles.adtailnet"];
  };

  services.nginx.virtualHosts."scrobbles.adtailnet" = {
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
