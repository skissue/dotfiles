{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.my.persist;
in {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.persist-retro.nixosModules.persist-retro
  ];

  environment.persistence."/local" = {
    hideMounts = true;
    directories = ["/var/lib/nixos"] ++ cfg.local.directories;
    files = ["/etc/machine-id"] ++ cfg.local.files;
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
}
