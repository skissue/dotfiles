{pkgs, ...}: {
  imports = [./mpd.nix];

  home.packages = with pkgs; [
    blender-hip
  ];
}
