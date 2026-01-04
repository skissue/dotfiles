{config, ...}: {
  sops.secrets.prowler-wireless-env = {
    # Hardcoded: https://github.com/NixOS/nixpkgs/blob/fb7944c166a3b630f177938e478f0378e64ce108/nixos/modules/services/networking/wpa_supplicant.nix#L689-L694
    owner = "wpa_supplicant";
    group = "wpa_supplicant";
  };

  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets.prowler-wireless-env.path;
    networks."JellyBean".pskRaw = "ext:JELLYBEAN_PSK";
  };
}
