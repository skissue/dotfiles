{config, ...}: let
  cfg = config.services.jellyfin;
in {
  services.jellyfin.enable = true;
  users.users.${cfg.user}.extraGroups = ["media"];

  services.nginx.virtualHosts."media.adtailnet" = {
    locations."/" = {
      proxyPass = "http://localhost:8096";
      proxyWebsockets = true;
    };
  };

  my.persist.data.directories = [
    {
      directory = cfg.dataDir;
      inherit (cfg) user group;
      mode = "700";
    }
  ];
}
