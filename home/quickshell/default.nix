{
  pkgs,
  inputs,
  mutable-link,
  osConfig,
  ...
}: let
  compiledShaders =
    pkgs.runCommandLocal "quickshell-shaders" {
      nativeBuildInputs = [pkgs.kdePackages.qtshadertools];
    } ''
      mkdir -p "$out/shaders"

      for shader in ${./config/shaders}/*.frag; do
        qsb --qt6 "$shader" -o "$out/shaders/$(basename "$shader").qsb"
      done
    '';
in {
  home.packages = with pkgs; [
    (inputs.quickshell.packages.${stdenv.hostPlatform.system}.default.withModules [
      kdePackages.qtmultimedia
    ])
    kdePackages.qtdeclarative # qmlls
    kdePackages.qtshadertools # qsb
  ];

  xdg.configFile."quickshell" = {
    # Keep mutable builds pointed directly at the working tree. In-tree QSB
    # files are intentionally used there so shader edits can be tested live.
    source =
      if osConfig.my.enable-mutable-links
      then mutable-link ./config
      else
        pkgs.symlinkJoin {
          name = "quickshell-config";
          paths = [
            ./config
            compiledShaders
          ];
        };
    recursive = true;
  };

  home.sessionVariables.QS_WALLPAPER_DIRECTORY = "${inputs.private}/wallpapers";
}
