{
  config,
  pkgs,
  ...
}: let
  cfg = config.services.jellyfin;
  graphicsPackages = with pkgs; [
    intel-media-driver
    libva-vdpau-driver
    intel-compute-runtime-legacy1
  ];
in {
  services.jellyfin.enable = true;
  users.users.${cfg.user}.extraGroups = ["media"];

  # https://wiki.nixos.org/wiki/Jellyfin#VAAPI_and_Intel_QSV
  # CPU is 7th generation (Kaby Lake).
  hardware.graphics = {
    enable = true;
    extraPackages = graphicsPackages;
  };
  chaotic.mesa-git.extraPackages = graphicsPackages;

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
