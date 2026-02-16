{inputs, ...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      background = {
        monitor = "";
        path = "${inputs.private}/wallpapers/0015.png";
      };

      input-field = {
        monitor = "";
        size = "600,60";
        placeholder_text = "$PAMPROMPT";
        outline_thickness = 2;
        dots_center = false;
        outer_color = "rgba(202, 211, 245, 0.5)";
        inner_color = "rgba(36, 39, 58, 0.6)";
        font_color = "rgb(202, 211, 245)";
        fade_on_empty = true;
        rounding = 8;
        position = "50,50";
        halign = "left";
        valign = "bottom";
      };

      label = [
        {
          # Clock - top left
          monitor = "";
          text = "$TIME";
          text_align = "left";
          font_size = 84;
          font_family = "PragmataPro";
          color = "rgba(202, 211, 245, 1.0)";
          position = "50,-10";
          halign = "left";
          valign = "top";
        }
        {
          # Date - below clock
          monitor = "";
          text = ''cmd[update:60000] date +"%A, %B %d, %Y"'';
          text_align = "left";
          font_size = 36;
          font_family = "PragmataPro";
          color = "rgba(202, 211, 245, 0.7)";
          position = "50,-120";
          halign = "left";
          valign = "top";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
