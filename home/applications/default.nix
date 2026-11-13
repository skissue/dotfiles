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
      # Drop deprecated GTK2 from the game runtime
      # <https://github.com/NixOS/nixpkgs/issues/410814#issuecomment-6574676195>
      buildFHSEnv = args:
        pkgs.buildFHSEnv (args
          // {
            multiPkgs = ps:
              pkgs.lib.filter
              (p: pkgs.lib.getName p != "gtk+")
              (args.multiPkgs ps);
          });
      extraLibraries = ps:
        with ps; [
          # TETR.IO
          nspr
          libxdamage
        ];
    })
    mangohud
    mullvad-browser
    nautilus
    obs-studio
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
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta
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
  };
}
