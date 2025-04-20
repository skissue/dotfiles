{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.jellyfin;
in {
  services.jellyfin.enable = true;
  users.users.${cfg.user}.extraGroups = ["media"];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver
    ];
  };

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
