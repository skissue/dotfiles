{
  config,
  pkgs,
  inputs,
  mutable-link,
  ...
}: let
  quickshell = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.withModules [
    pkgs.kdePackages.qtmultimedia
  ];
  # TODO ugly!
  wrappedQuickshell = pkgs.symlinkJoin {
    name = "quickshell-wallpaper";
    paths = [quickshell];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      for bin in qs quickshell; do
        wrapProgram "$out/bin/$bin" \
          --set QS_WALLPAPER_DIRECTORY ${pkgs.lib.escapeShellArg "${inputs.private}/wallpapers"}
      done
    '';
    inherit (quickshell) meta;
  };

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
  users.users.${config.my.user.name}.packages = with pkgs; [
    wrappedQuickshell
    kdePackages.qtdeclarative # qmlls
    kdePackages.qtshadertools # qsb
  ];

  hjem.users.${config.my.user.name} = {
    systemd.services.quickshell = {
      description = "Quickshell desktop shell";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      startLimitIntervalSec = 30;
      startLimitBurst = 3;
      unitConfig.ConditionEnvironment = ["WAYLAND_DISPLAY" "NIRI_SOCKET"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${wrappedQuickshell}/bin/qs";
        Slice = "session-graphical.slice";
        Restart = "on-failure";
        RestartSec = 1;
      };
    };

    xdg.config.files."quickshell".source =
      # Manual conditional because we need to use the tree with compiled shaders
      # for normal builds.
      if config.my.enable-mutable-links
      then mutable-link ./config
      else
        pkgs.symlinkJoin {
          name = "quickshell-config";
          paths = [
            ./config
            compiledShaders
          ];
        };
  };

  # Let Home Manager retire its old link before Hjem takes ownership.
  # TODO remove
  systemd.services."hjem-activate@${config.my.user.name}" = {
    overrideStrategy = "asDropin";
    requires = ["home-manager-${config.my.user.name}.service"];
    after = ["home-manager-${config.my.user.name}.service"];
  };
}
