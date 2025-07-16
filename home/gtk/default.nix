{
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    font = {
      name = "Atkinson Hyperlegible Next";
      size = 12;
    };
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}
