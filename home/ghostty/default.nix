{config, ...}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "kusanagi";
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
  };

  # Needed for proper D-Bus integration.
  # See https://ghostty.org/docs/linux/systemd
  dbus.packages = [config.programs.ghostty.package];
}
