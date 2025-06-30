{
  config,
  pkgs,
  sources,
  ...
}: {
  home.packages = with pkgs; [
    anki
    aria
    bottom
    brave
    brightnessctl
    simple-scan
    ffmpeg
    fractal
    gpu-screen-recorder
    helvum
    # For spellcheck; see https://nixos.wiki/wiki/LibreOffice
    hunspell
    hunspellDicts.en_US
    # Avoid building two copies of Hyprland
    (hyprshot.override {hyprland = config.wayland.windowManager.hyprland.package;})
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
    plover.dev
    prismlauncher
    pwvucontrol_git
    ripgrep
    ripgrep-all
    satty
    signal-desktop
    swaybg
    tor-browser-bundle-bin
    ungoogled-chromium
    waypipe
    webcord
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
      (buildLua sources.mpv-skipsilence)
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
    "WebCord/Themes/theme".text = ''
      * {
        font-family: Atkinson Hyperlegible Next, sans-serif;
      }
    '';
  };
}
