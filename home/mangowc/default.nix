{
  pkgs,
  mutable-link,
  inputs,
  ...
}: {
  imports = [inputs.mangowc.hmModules.mango];
  wayland.windowManager.mango = {
    enable = true;
    systemd.enable = false; # Handled by uwsm.

    # Use a `source` instead of setting directly so that devices can easily add
    # extra configuration while keeping mutable-links possible.
    settings = ''
      source=${mutable-link ./config.conf}

      exec-once=uwsm-app -s b -- swaybg -m fill -i ${inputs.private}/wallpapers/0008.png
      exec-once=uwsm finalize
    '';
  };

  home.packages = with pkgs; [
    mako
    wlr-randr
    grim
    slurp
  ];

  home.sessionPath = [(toString ./scripts)];

  programs.fuzzel.settings.main.launch-prefix = "uwsm-app --";

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
        path = "${inputs.private}/wallpapers/0015.png";
      };

      input-field = {
        monitor = "";
        size = "600,60";
        placeholder_text = "$PAMPROMPT";
        outline_thickness = 2;
        dots_center = false;
        outer_color = "rgba(202, 211, 245, 0.5)";
        inner_color = "rgba(36, 39, 58, 0.6)";
        font_color = "rgb(202, 211, 245)";
        fade_on_empty = true;
        rounding = 8;
        position = "50,50";
        halign = "left";
        valign = "bottom";
      };

      label = [
        {
          # Clock - top left
          monitor = "";
          text = "$TIME";
          text_align = "left";
          font_size = 84;
          font_family = "PragmataPro";
          color = "rgba(202, 211, 245, 1.0)";
          position = "50,-10";
          halign = "left";
          valign = "top";
        }
        {
          # Date - below clock
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %B %d, %Y"'';
          text_align = "left";
          font_size = 36;
          font_family = "PragmataPro";
          color = "rgba(202, 211, 245, 0.7)";
          position = "50,-120";
          halign = "left";
          valign = "top";
        }
      ];
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
    "NIXOS_OZONE_WL" = "1";
  };
}
