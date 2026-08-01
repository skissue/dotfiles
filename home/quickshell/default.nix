{
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  home.packages = with pkgs; [
    inputs.quickshell.packages.${stdenv.hostPlatform.system}.default
    kdePackages.qtdeclarative # qmlls
    kdePackages.qtshadertools # qsb
  ];

  xdg.configFile."quickshell" = {
    source = mutable-link ./config;
    recursive = true;
  };

  home.sessionVariables.QS_WALLPAPER_DIRECTORY = "${inputs.private}/wallpapers";
}
