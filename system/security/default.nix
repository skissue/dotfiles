{
  lib,
  pkgs,
  ...
}: {
  imports = [./run0.nix];

  security.protectKernelImage = lib.mkDefault true;

  # Block this module until LPE is fixed
  # See: <https://lore.kernel.org/all/20261112172149.27355-1-yves.bieri@theori.io/>
  # TODO remove when kernel updates fix this
  boot.extraModprobeConfig = ''
    install sctp ${pkgs.coreutils}/bin/false
  '';

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "init_on_alloc=1"
    "init_on_free=1"
    "slab_nomerge"
    "page_alloc.shuffle=1"
  ];

  # Hide restricted kernel pointers even from CAP_SYSLOG.
  boot.kernel.sysctl."kernel.kptr_restrict" = lib.mkOverride 500 2;
}
