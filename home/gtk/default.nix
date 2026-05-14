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
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk4.theme = config.gtk.theme;
  };
}
