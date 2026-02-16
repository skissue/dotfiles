{
  pkgs,
  mutable-link,
  inputs,
  ...
}: {
  imports = [
    inputs.mangowc.hmModules.mango
    ./hyprlock.nix
    ./mako.nix
  ];

  wayland.windowManager.mango = {
    enable = true;
    systemd.enable = false; # Handled by uwsm.

    # Use a `source` instead of setting directly so that devices can easily add
    # extra configuration while keeping mutable-links possible.
    settings = ''
      source=${mutable-link ./config.conf}

      exec-once=runapp -i background-graphical.slice -- swaybg -m fill -i ${inputs.private}/wallpapers/0008.png
      exec-once=uwsm finalize
    '';
  };

  home.packages = with pkgs; [
    wlr-randr
    runapp
    grim
    slurp
  ];

  home.sessionPath = [(toString ./scripts)];

  programs.fuzzel.settings.main.launch-prefix = "runapp --";

  home.sessionVariables = {
    "XDG_SESSION_TYPE" = "wayland";
    "QT_QPA_PLATFORM" = "wayland;xcb";
    "QT_WAYLAND_DISABLE_WINDOWDECORATION" = "1";
    "SDL_VIDEODRIVER" = "wayland,x11";
    "CLUTTER_BACKEND" = "wayland";
    "NIXOS_OZONE_WL" = "1";
  };
}
