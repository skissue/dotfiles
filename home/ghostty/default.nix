{config, ...}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "alabaster-dark";
      font-family = "PragmataPro Mono Liga";
      font-size = 14;
      background-opacity = 0.85;
      command = "nu";
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "no-bell,notify";
    };
    themes.kusanagi = {
      background = "050810";
      foreground = "68b8cc";
      cursor-color = "00e5ff";
      cursor-text = "050810";
      selection-background = "0d2840";
      selection-foreground = "8ecede";
      palette-generate = true;
      palette = [
        "0=#080c16"
        "1=#ff0044"
        "2=#00cc77"
        "3=#ffaa00"
        "4=#00b8cc"
        "5=#cc55ff"
        "6=#00c5dd"
        "7=#68b8cc"
        "8=#1a3a50"
        "9=#ff4466"
        "10=#00cc77"
        "11=#ffaa00"
        "12=#00e5ff"
        "13=#ff4466"
        "14=#8ecede"
        "15=#8ecede"
      ];
    };
    themes.alabaster-dark = {
      background = "0E1415";
      foreground = "CECECE";
      cursor-color = "CD974B";
      cursor-text = "293334";
      selection-background = "293334";
      selection-foreground = "CECECE";
      palette = [
        "0=#0E1415"
        "1=#e25d56"
        "2=#73ca50"
        "3=#e9bf57"
        "4=#4a88e4"
        "5=#915caf"
        "6=#23acdd"
        "7=#f0f0f0"
        "8=#777777"
        "9=#f36868"
        "10=#88db3f"
        "11=#f0bf7a"
        "12=#6f8fdb"
        "13=#e987e9"
        "14=#4ac9e2"
        "15=#FFFFFF"
      ];
    };
  };

  # Needed for proper D-Bus integration.
  # See https://ghostty.org/docs/linux/systemd
  dbus.packages = [config.programs.ghostty.package];
}
