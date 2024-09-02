{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    anki
    brave
    brightnessctl
    simple-scan
    ffmpeg
    fractal
    gamescope
    imv
    keepassxc
    libnotify
    libreoffice
    libsecret
    lutris
    helvum
    # For spellcheck; see https://nixos.wiki/wiki/LibreOffice
    hunspell
    hunspellDicts.en_US
    # Avoid building two copies of Hyprland
    (hyprshot.override {hyprland = config.wayland.windowManager.hyprland.package;})
    mangohud
    mullvad-browser
    my.tetrio-desktop
    nextcloud-client
    obs-studio
    pavucontrol
    pcmanfm
    playerctl
    prismlauncher
    signal-desktop
    swappy
    swaybg
    tor-browser-bundle-bin
    ungoogled-chromium
    waypipe
    webcord
    wf-recorder
    wl-clipboard
    my.zen-browser
  ];

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      mpris
      modernx
      thumbfast
      mpv-cheatsheet
    ];
  };

  services.easyeffects.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "application/pdf" = "emacsclient.desktop";
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "zen-browser.desktop";
    "x-scheme-handler/https" = "zen-browser.desktop";
  };
  xdg.configFile = {
    "swappy/config".text = ''
      [Default]
      show_panel=true
      paint_mode=rectangle
      fill_shape=true
    '';
    "WebCord/Themes/theme".text = ''
      * {
        font-family: Iosevka Aile, sans-serif;
      }
    '';
  };
}
