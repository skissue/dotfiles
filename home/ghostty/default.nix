{config, ...}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "ef-owl";
      font-family = "PragmataPro Mono";
      font-size = 14;
      background-opacity = 0.85;
      command = "nu";
    };
    themes.ef-owl = {
      # https://codeberg.org/anhsirk0/ghostty-themes/src/branch/main/themes/ef-owl ❤️
      # Ef-Owl Colors
      background = "#292c2f";
      foreground = "#d0d0d0";
      selection-background = "#404f66";
      selection-foreground = "#d0d0d0";
      cursor-color = "#afe6ef";

      palette = [
        # black
        "0=#373b3d"
        "8=#60676b"
        # red
        "1=#d67869"
        "9=#e4959f"
        # green
        "2=#70bb70"
        "10=#60bd90"
        # yellow
        "3=#c09f6f"
        "11=#cf9f90"
        # blue
        "4=#80a4e0"
        "12=#72aff0"
        # magenta
        "5=#e5a0ea"
        "13=#cfa0e8"
        # cyan
        "6=#8fb8ea"
        "14=#7ac0b9"
        # white
        "7=#d0d0d0"
        "15=#857f8f"
      ];
    };
  };

  # Needed for proper D-Bus integration.
  # See https://ghostty.org/docs/linux/systemd
  dbus.packages = [config.programs.ghostty.package];
}
