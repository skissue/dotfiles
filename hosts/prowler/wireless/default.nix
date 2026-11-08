{
  config,
  secretsDir,
  ...
}: {
  sops.secrets.prowler-wireless = {
    sopsFile = "${secretsDir}/prowler.yaml";
    owner = "wpa_supplicant";
    mode = "0400";
    restartUnits = ["wpa_supplicant.service"];
  };

  networking.wireless.extraConfigFiles = [config.sops.secrets.prowler-wireless.path];
}
