{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [./theme.toml];
      terminal.shell.program = "nu";
      window = {
        opacity = 0.85;
        padding = {
          x = 4;
          y = 4;
        };
        dynamic_padding = true;
      };
      colors.transparent_background_colors = true;
      font = {
        normal.family = "Iosevka Term SS18";
        size = 14;
        builtin_box_drawing = false;
      };
      bell = {
        duration = 150;
        color = "0xD8DEE9";
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        blink_interval = 600;
        blink_timeout = 0;
      };
    };
  };
  home.sessionVariables."TERMINAL" = "alacritty";
}
