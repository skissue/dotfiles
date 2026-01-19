{
  imports = [
    ./fonts
    ./gaming
    ./greetd
    ./kanata
    ./mangowc
    ./pipewire
    ./usbs
  ];

  services.logind.settings.Login.HandlePowerKey = "suspend";

  services.fwupd.enable = true;

  # Emacs ispell
  environment.wordlist.enable = true;

  # `man -k` and other manual searchers (like Emacs)
  documentation.man.generateCaches = true;

  # For `setcap` permissions. Does NOT install the actual executable.
  programs.gpu-screen-recorder.enable = true;

  # Allow Plover to access serial (Gemini PR) devices.
  my.user.extraGroups = ["dialout"];

  # Also enables services for smart card functionality.
  programs.yubikey-manager.enable = true;
}
