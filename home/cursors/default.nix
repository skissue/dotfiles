{
  config,
  pkgs,
  ...
}: {
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.macchiatoPink;
    name = "catppuccin-macchiato-pink-cursors";
    size = 36;
    gtk.enable = true;
  };

  home.sessionVariables = {
    "HYPRCURSOR_THEME" = config.home.pointerCursor.name;
    "HYPRCURSOR_SIZE" = config.home.pointerCursor.size;
  };
}
