{config, ...}: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-family = "PragmataPro Mono Liga";
      font-size = 14;
      background-opacity = 0.85;
      command = "nu";
      notify-on-command-finish = "unfocused";
      notify-on-command-finish-action = "no-bell,notify";
    };
  };

  # Needed for proper D-Bus integration.
  # See https://ghostty.org/docs/linux/systemd
  dbus.packages = [config.programs.ghostty.package];
}
