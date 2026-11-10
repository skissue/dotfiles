{
  config,
  pkgs,
  private,
  ...
}: let
  cfg = config.services.jellyfin;
  domain = "media.${private.domain.internal}";
in {
  services.jellyfin.enable = true;
  users.users.${cfg.user}.extraGroups = ["media"];

  # https://wiki.nixos.org/wiki/Jellyfin#VAAPI_and_Intel_QSV
  # CPU is 7th generation (Kaby Lake).
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libva-vdpau-driver
      intel-compute-runtime-legacy1
    ];
  };

  services.caddy.virtualHosts.${domain} = {
    useACMEHost = "internal";
    extraConfig = ''
      reverse_proxy http://localhost:8096
    '';
  };

  my.persist.data.directories = [
    {
      directory = cfg.dataDir;
      inherit (cfg) user group;
      mode = "700";
    }
  ];
}
