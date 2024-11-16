{
  pkgs,
  inputs,
  mutable-link,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      # Crashing right now and I don't feel like figuring out why.
      # inputs.hypr-dynamic-cursors.packages.${pkgs.system}.default
      inputs.hyprfocus.packages.${pkgs.system}.default
      inputs.hyprscroller.packages.${pkgs.system}.default
    ];
    extraConfig = ''
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

    font=Iosevka Aile 16
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
        font_family = "Iosevka Aile";
        position = "0, 80";
        halign = "center";
        valign = "center";
      };
    };
  };

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
