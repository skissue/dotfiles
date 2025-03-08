{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Atkinson Hyperlegible Next:size=18";
        dpi-aware = "no";
        prompt = "❯ ";
        lines = 20;
        width = 40;
        tabs = 4;
        horizontal-pad = 8;
        vertical-pad = 8;
        inner-pad = 4;
      };
      colors = {
        background = "000000d8";
        text = "989898ff";
        match = "ffffffff";
        selection = "535353bf";
        selection-text = "989898ff";
        selection-match = "ffffffff";
      };
      border = {
        width = 0;
        radius = 0;
      };
    };
  };

  home.sessionVariables = {
    "LAUNCHER" = "fuzzel";
    "DMENU" = "fuzzel --dmenu";
  };
}
