{inputs, pkgs, ...}: {
  nixpkgs.overlays = [inputs.cachyos-kernel.overlays.pinned];

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
}
