{
  config,
  lib,
  inputs,
  ...
}: let
  btrfsRollbackScript = ''
    mkdir /btrfs_tmp
    mount /dev/disk/by-label/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/root.old
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/root.old/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/root.old/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
  cfg = config.my.persist;
in {
  imports = [inputs.impermanence.nixosModules.impermanence inputs.persist-retro.nixosModules.persist-retro];

  environment.persistence."/local" = {
    hideMounts = true;
    directories = ["/var/lib/nixos"] ++ cfg.local.directories;
    files = cfg.local.files;
  };
  environment.persistence."/data" = {
    hideMounts = true;
    directories = cfg.data.directories;
    files = cfg.data.files;
  };

  fileSystems."/local".neededForBoot = true;
  fileSystems."/data".neededForBoot = true;

  # https://github.com/Mic92/sops-nix/issues/149
  #
  # TL;DR Sops sets up secrets before impermanence binds persistent directories;
  # as a simple workaround, we can instruct sops to pull secrets from the
  # persistent volume directly.
  sops.age.sshKeyPaths = ["/local/etc/ssh/ssh_host_ed25519_key"];

  # Wiping root via Btrfs subvolumes, taken from
  # https://github.com/nix-community/impermanence/blob/master/README.org#btrfs-subvolumes
  #
  # systemd initrd doesn't support `boot.initrd.postDeviceCommands`, so we use a service if that's enabled instead.
  boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (lib.mkAfter btrfsRollbackScript);
  boot.initrd.systemd.services.impermanence-wipe-root = {
    description = "Restore root subvolume to empty state (impermanence)";
    before = ["sysroot.mount"];
    wantedBy = ["initrd.target"];
    serviceConfig.Type = "oneshot";
    script = btrfsRollbackScript;
  };
}
