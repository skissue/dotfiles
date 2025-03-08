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
      name = "catppuccin-macchiato-pink-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        variant = "macchiato";
      };
    };
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}
