{
  config,
  lib,
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    # Recommended to disable when using `uwsm`; see
    # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/
    systemd.enable = false;
    plugins = [
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.default
    ];
    extraConfig = lib.mkAfter ''
      source = ${mutable-link ./hyprland.conf}
    '';
  };

  home.packages = with pkgs; [
    mako
  ];
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
    package = inputs.hyprlock.packages.${pkgs.system}.default;
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
        before_sleep_cmd = lib.mkDefault "loginctl lock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session; hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
  # For some reason, the default setting for this (WAYLAND_DISPLAY) results in
  # it failing to start. Too lazy to debug my startup ordering (probably
  # something to do with UWSM), so just gonna remove the precondition ¯\_(ツ)_/¯.
  systemd.user.services.hypridle.Unit.ConditionEnvironment = lib.mkForce "";

  home.sessionVariables = {
    "XDG_SESSION_TYPE" = "wayland";
    "QT_QPA_PLATFORM" = "wayland;xcb";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "SDL_VIDEODRIVER" = "wayland";
    "CLUTTER_BACKEND" = "wayland";
    "ANKI_WAYLAND" = "1";
    "NIXOS_OZONE_WL" = "1";
  };

  home.sessionPath = [(toString ./scripts)];
}
