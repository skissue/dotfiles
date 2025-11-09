{
  pkgs,
  sources,
  ...
}: {
  home.packages = with pkgs; [
    aria2
    bottom
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
      extraLibraries = ps:
        with ps; [
          # TETR.IO
          nspr
          xorg.libXdamage
        ];
    })
    mangohud
    mullvad-browser
    nautilus
    nextcloud-client
    obs-studio
    ouch
    playerctl
    prismlauncher
    pwvucontrol
    qpwgraph
    ripgrep
    ripgrep-all
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
      mpv-cheatsheet
      skipsilence
    ];
  };

  services.easyeffects.enable = true;
  services.kdeconnect.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "zen-browser.desktop";
    "x-scheme-handler/https" = "zen-browser.desktop";
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
}
