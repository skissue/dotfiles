{config, ...}: {
  sops.secrets.prowler-wireless-env = {};
  
  networking.wireless = {
    enable = true;
    environmentFile = config.sops.secrets.prowler-wireless-env.path;
    networks."JellyBean".psk = "@JELLYBEAN_PSK@";
  };
}
