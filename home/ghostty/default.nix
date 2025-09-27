{config, ...}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      font-family = "Maple Mono NF";
      font-size = 12;
      background-opacity = 0.85;
      command = "nu";
    };
  };

  # Needed for proper D-Bus integration.
  # See https://ghostty.org/docs/linux/systemd
  dbus.packages = [config.programs.ghostty.package];
}
