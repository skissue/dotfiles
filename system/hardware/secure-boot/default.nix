{lib, inputs,...}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.initrd.systemd.enable = true; # For TPM2 LUKS unlock

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  my.persist.local.directories = ["/etc/secureboot"];
}
