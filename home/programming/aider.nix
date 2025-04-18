{pkgs, ...}: {
  home.packages = with pkgs; [aider-chat-with-playwright];

  programs.git.ignores = ["/.aider*"];

  # Too lazy to make a YAML file.
  home.sessionVariables = {
    "AIDER_GITIGNORE" = "false";
    "AIDER_AUTO_COMMITS" = "false";
    "AIDER_WATCH_FILES" = "true";
    "AIDER_ANALYTICS_DISABLE" = "true";
    "AIDER_NOTIFICATIONS" = "true";
    "AIDER_SHOW_MODEL_WARNINGS" = "false";
  };
}
