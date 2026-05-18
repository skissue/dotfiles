{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    aria2
    blender
    bottom
    inputs.bouncer.packages.${pkgs.stdenv.hostPlatform.system}.default
    brave
    brightnessctl
    inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    inputs.crack.packages.${pkgs.stdenv.hostPlatform.system}.default
    simple-scan
    ffmpeg
    gpu-screen-recorder
    # For spellcheck; see https://nixos.wiki/wiki/LibreOffice
    hunspell
    hunspellDicts.en_US
    imv
    keepassxc
    libnotify
    libreoffice
    libsecret
    (lutris.override {
      extraLibraries = ps:
        with ps; [
          # TETR.IO
          nspr
          libxdamage
        ];
      # HACK Fix build until <https://github.com/nixos/nixpkgs/pull/515956> is in
      # nixos-unstable. Source:
      # <https://github.com/NixOS/nixpkgs/issues/513245#issuecomment-4319854191>
      buildFHSEnv = args:
        pkgs.buildFHSEnv (args
          // {
            multiPkgs = envPkgs: let
              # Fetch original package list
              originalPkgs = args.multiPkgs envPkgs;

              # Disable tests for openldap
              customLdap = envPkgs.openldap.overrideAttrs (_: {doCheck = false;});
            in
              # Replace broken openldap with the custom one
              builtins.filter (p: (p.pname or "") != "openldap") originalPkgs ++ [customLdap];
          });
    })
    mangohud
    mullvad-browser
    nautilus
    (obs-studio.override {browserSupport = false;})
    opencode
    ouch
    playerctl
    prismlauncher
    pwvucontrol
    qpwgraph
    ripgrep
    satty
    signal-desktop
    swaybg
    tor-browser
    ungoogled-chromium
    waypipe
    wl-clipboard
    yt-dlp
    my.zen-browser
  ];

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      modernx
      thumbfast
      mpv-cheatsheet-ng
      skipsilence
    ];
  };

  services.easyeffects.enable = true;
  services.kdeconnect.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "bouncer.desktop";
    "x-scheme-handler/https" = "bouncer.desktop";
  };
  xdg.configFile = {
    "satty/config.toml".source = (pkgs.formats.toml {}).generate "satty-config" {
      general = {
        fullscreen = true;
        early-exit = true;
        copy-command = "wl-copy";
        initial-tool = "rectangle";
      };
      font = {family = "Atkinson Hyperlegible Next";};
    };
  };
  home.sessionVariables = {
    CLAUDE_USE_WAYLAND = 1;
  };
}
