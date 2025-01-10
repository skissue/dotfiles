{
  wayland.windowManager.hyprland.extraConfig = ''
    input {
        kb_options = caps:escape
    }

    monitor = eDP-1,2256x1504@60,0x0,1.566667

    bindl = ,switch:on:Lid Switch,exec,systemctl suspend
  '';

  programs.hyprlock.settings = {
    auth.fingerprint.enabled = true;
  };
}
