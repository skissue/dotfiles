# Wiping root on Bcachefs via subvolumes, based on
# https://gurevitch.net/bcachefs-impermanence/#impermanence
#
# Assumptions made about filesystem structure:
# - The Bcachefs partition has label "nixos".
# - The existing root partition is in a subvolume at "@root".
# - There is a blank subvolume at @blank_root which will be snapshotted to the new root.
{
  config,
  lib,
  ...
}: let
  bcachefsRollbackScript = ''
    mkdir /bcachefs_tmp
    mount -t bcachefs /dev/disk/by-label/nixos /bcachefs_tmp

    if [[ -e /bcachefs_tmp/@root ]]; then
        mkdir -p /bcachefs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /bcachefs_tmp/@root)" "+%Y-%m-%-dT%H:%M:%S")
        mv /bcachefs_tmp/@root "/bcachefs_tmp/old_roots/$timestamp"
    fi

    # TODO delete roots older than 30 days
    #for i in $(find /bcachefs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
    #    chattr -i "$i"/var/empty
    #    bcachefs subvolume delete "$i"
    #done

    bcachefs subvolume snapshot /bcachefs_tmp/@blank_root /bcachefs_tmp/@root
    umount /bcachefs_tmp
  '';
in {
  boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (lib.mkAfter bcachefsRollbackScript);

  # systemd initrd doesn't support `boot.initrd.postDeviceCommands`, so we use a
  # service if that's enabled instead.
  boot.initrd.systemd.services.impermanence-wipe-root = {
    description = "Restore root subvolume to empty state (impermanence)";
    before = ["sysroot.mount"];
    wantedBy = ["initrd.target"];
    serviceConfig.Type = "oneshot";
    script = bcachefsRollbackScript;
  };
}
