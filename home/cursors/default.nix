{
  config,
  pkgs,
  ...
}: {
  home.pointerCursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors-white";
    size = 36;
    gtk.enable = true;
  };

  home.sessionVariables = {
    "HYPRCURSOR_THEME" = config.home.pointerCursor.name;
    "HYPRCURSOR_SIZE" = config.home.pointerCursor.size;
  };
}
