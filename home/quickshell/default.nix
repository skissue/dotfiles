{
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  home.packages = [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  xdg.configFile."quickshell" = {
    source = mutable-link ./config;
    recursive = true;
  };
}
