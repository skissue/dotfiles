{
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}: let
  escape = lib.strings.escapeC ["-"];
  mkUsbConfig = name: uuid: let
    deviceUnit = "dev-disk-${escape "by-uuid"}-${escape uuid}.device";
  in {
    sops.secrets."usbs/${name}".sopsFile = "${secretsDir}/desktop.yaml";

    systemd.services.${"automount-${name}"} = {
      description = "Auto-decrypt and mount ${name} USB drive";
      wantedBy = [deviceUnit];
      bindsTo = [deviceUnit];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        KeyringMode = "shared";
      };

      path = with pkgs; [bcachefs-tools util-linux];
      script = ''
        #!${pkgs.runtimeShell}
        mkdir -p /media/${name}
        bcachefs mount \
          -f ${config.sops.secrets."usbs/${name}".path} \
          -o noatime,nodev,nosuid,noexec \
          UUID=${uuid} /media/${name}
      '';
      postStop = ''
        umount /media/${name}
      '';
    };
  };
in
  lib.mkMerge [
    (mkUsbConfig "blastpack" "f4681cd9-8f04-4b78-a73d-baaa0baefef8")
    (mkUsbConfig "storebeacon" "1c314473-40e4-4b20-9c48-8fe9182ce602")
  ]
