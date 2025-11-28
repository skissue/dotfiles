{config, ...}: let
  cfg = config.services.caddy;
in {
  networking.firewall.allowedTCPPorts = [80 443];

  services.caddy.enable = true;

  my.persist.local.directories = [
    {
      directory = cfg.dataDir;
      user = cfg.user;
      group = cfg.group;
      mode = "700";
    }
  ];
}
