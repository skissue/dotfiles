{config, ...}: {
  # TODO placeholder until applications move out of HM
  hjem.users.${config.my.user.name}.xdg.mime-apps.default-applications = {
    "text/plain" = "emacsclient.desktop";
    "text/org" = "emacsclient.desktop";
    "application/pdf" = "emacsclient.desktop";
    "x-scheme-handler/mailto" = "emacsclient.desktop";

    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "text/html" = "zen-beta.desktop";
    "x-scheme-handler/http" = "bouncer.desktop";
    "x-scheme-handler/https" = "bouncer.desktop";
  };
}
