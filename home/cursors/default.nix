{
  config,
  pkgs,
  ...
}: {
  home.pointerCursor = {
    # Only include the variants I care about
    package = pkgs.nordzy-cursor-theme.overrideAttrs (_: {
      installPhase = ''
        mkdir -p $out/share/icons
        cp -r xcursors/Nordzy-cursors-white $out/share/icons/
        cp -r hyprcursors/themes/Nordzy-hyprcursors-white $out/share/icons/
      '';
    });
    name = "Nordzy-cursors-white";
    size = 36;
    gtk.enable = true;
  };

  home.sessionVariables = {
    "HYPRCURSOR_THEME" = config.home.pointerCursor.name;
    "HYPRCURSOR_SIZE" = config.home.pointerCursor.size;
  };
}
