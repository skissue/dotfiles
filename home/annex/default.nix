{pkgs,inputs, ...}: {
  home.packages = with pkgs; [
    git-annex
    inputs.git-annex-backend-XBLAKE3.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
