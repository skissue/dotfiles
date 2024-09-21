{config, ...}: {
  sops.secrets.prowler-wireless-env = {};

  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets.prowler-wireless-env.path;
    networks."JellyBean".pskRaw = "ext:JELLYBEAN_PSK";
  };
}
