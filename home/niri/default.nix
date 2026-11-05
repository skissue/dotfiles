{
  pkgs,
  mutable-link,
  ...
}: {
  home.packages = with pkgs; [xwayland-satellite-unstable wl-kbptr runapp];

  xdg.configFile."niri/config.kdl".source = mutable-link ./config.kdl;
  xdg.configFile."niri/animations".source = mutable-link ./animations;

  home.sessionPath = [(toString ./scripts)];

  programs.fuzzel.settings.main.launch-prefix = "runapp --";

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "qs ipc call lock activate";
        # Quickshell handler will lock system
        before_sleep_cmd = "qs ipc call sleep prepare";
        after_sleep_cmd = "qs ipc call sleep resume";
        # Wait for a session lock
        inhibit_sleep = 3;
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
