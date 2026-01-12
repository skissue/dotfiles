{
  pkgs,
  mutable-link,
  inputs,
  ...
}: {
  imports = [inputs.mangowc.hmModules.mango];

  wayland.windowManager.mango.enable = true;
  
  home.packages = with pkgs; [mako];

  xdg.configFile."mango/config.conf".source = mutable-link ./config.conf;

  home.sessionPath = [(toString ./scripts)];

  # xdg.configFile."mako/config".text = ''
  #   default-timeout=5000
  #   group-by=app-name,summary
  #   layer=overlay
  #
  #   font=Atkinson Hyperlegible Next 16
  #   background-color=#24273ad9
  #   text-color=#cad3f5
  #
  #   width=500
  #   height=200
  #   border-size=0
  #
  #   on-notify=exec pw-play ${./zoom.ogg}
  #   on-button-middle=exec makoctl menu -n "$id" $DMENU -p 'Select action: '
  # '';

  programs.hyprlock = {
    enable = true;
    settings = {
      # Disable fade-in, which causes a red flash on niri.
      animation = ["fadeIn,0"];
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
    "NIXOS_OZONE_WL" = "1";
  };
}
