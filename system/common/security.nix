{
  lib,
  pkgs,
  ...
}: {
  security.protectKernelImage = lib.mkDefault true;

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
