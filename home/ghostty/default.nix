{config, ...}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "doric-obsidian";
      font-family = "PragmataPro Mono Liga";
      font-size = 14;
      background-opacity = 0.85;
      command = "nu";
    };
    themes.doric-obsidian = {
      # https://codeberg.org/anhsirk0/ghostty-themes/src/branch/main/themes/doric-obsidian ❤️
      # Doric-Obsidian Colors
      background = "#181818";
      foreground = "#e7e7e7";
      selection-background = "#505050";
      selection-foreground = "#e7e7e7";
      cursor-color = "#eeddbb";

      palette = [
        # black
        "0=#2f2f2f"
        "8=#2f2f2f"
        # red
        "1=#eca28f"
        "9=#eca28f"
        # green
        "2=#b9d0aa"
        "10=#b9d0aa"
        # yellow
        "3=#c0b080"
        "11=#c0b080"
        # blue
        "4=#9fbfe7"
        "12=#9fbfe7"
        # magenta
        "5=#e9acbf"
        "13=#e9acbf"
        # cyan
        "6=#a0c0d0"
        "14=#a0c0d0"
        # white
        "7=#e7e7e7"
        "15=#e7e7e7"
      ];
    };
  };

  # Needed for proper D-Bus integration.
  # See https://ghostty.org/docs/linux/systemd
  dbus.packages = [config.programs.ghostty.package];
}
