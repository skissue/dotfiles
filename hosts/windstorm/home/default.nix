{pkgs, ...}: {
  imports = [./mpd.nix];

  home.packages = with pkgs; [
    blender-hip
  ];

  wayland.windowManager.hyprland.extraConfig = ''
    monitor   = DP-2,2560x1440@144,0x0,1.25
    monitor   = HDMI-A-1,1920x1080@60,2048x360,1
    workspace = 1,monitor:DP-2,default:true
    workspace = 2,monitor:DP-2
    workspace = 3,monitor:DP-2
    workspace = 4,monitor:DP-2
    workspace = 5,monitor:DP-2
    workspace = 6,monitor:DP-2
    workspace = 7,monitor:DP-2
    workspace = 8,monitor:DP-2
    workspace = 9,monitor:DP-2
    workspace = 10,monitor:HDMI-A-1,default:true

    misc {
        vrr = 1
    }

    $dpmsExtra = && ddcutil setvcp d6 04
    $undpmsExtra = && ddcutil setvcp d6 01
  '';
}
