{
  pkgs,
  mutable-link,
  ...
}: {
  home.packages = with pkgs; [xwayland-satellite-unstable mako];

  xdg.configFile."niri/config.kdl".source = mutable-link ./config.kdl;

  home.sessionPath = [(toString ./scripts)];

  xdg.configFile."mako/config".text = ''
    default-timeout=5000
    group-by=app-name,summary
    layer=overlay

    font=Atkinson Hyperlegible Next 16
    background-color=#24273ad9
    text-color=#cad3f5

    width=500
    height=200
    border-size=0

    on-notify=exec pw-play ${./zoom.ogg}
    on-button-middle=exec makoctl menu -n "$id" $DMENU -p 'Select action: '
  '';

  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 6;
      };
      input-field = {
        monitor = "";
        size = "400, 50";
        placeholder_text = "$PROMPT";
        dots_center = false;
        halign = "center";
        valign = "center";
      };
      label = {
        monitor = "";
        text = "$TIME";
        text_align = "center";
        font_size = 36;
        font_family = "Atkinson Hyperlegible Next";
        position = "0, 80";
        halign = "center";
        valign = "center";
      };
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  home.sessionVariables = {
    "XDG_SESSION_TYPE" = "wayland";
    "QT_QPA_PLATFORM" = "wayland;xcb";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "SDL_VIDEODRIVER" = "wayland,x11";
    "CLUTTER_BACKEND" = "wayland";
    "ANKI_WAYLAND" = "1";
    "NIXOS_OZONE_WL" = "1";
  };
}
