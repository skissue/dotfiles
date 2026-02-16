{pkgs, ...}: {
  home.packages = [pkgs.mako];

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
}
