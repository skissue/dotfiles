{
  imports = [./fonts ./gaming ./greetd ./hyprland ./pipewire];

  services.logind.powerKey = "suspend";

  # Emacs ispell
  environment.wordlist.enable = true;

  # `man -k` and other manual searchers (like Emacs)
  documentation.man.generateCaches = true;

  # For `setcap` permissions. Does NOT install the actual executable.
  programs.gpu-screen-recorder.enable = true;
}
