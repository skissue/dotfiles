{
  config,
  pkgs,
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
    nextcloud-client
    obs-studio
    ouch
    pcmanfm
    playerctl
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
  services.kdeconnect.enable = true;

  xdg.mimeApps.defaultApplications = {
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "application/pdf" = "emacsclient.desktop";
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
      font = {family = "Iosevka Aile";};
    };
    "WebCord/Themes/theme".text = ''
      * {
        font-family: Iosevka Aile, sans-serif;
      }
    '';
  };
}
