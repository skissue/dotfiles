# https://docs.ntfy.sh/examples/#ssh-login-alerts
{
  lib,
  pkgs,
  ...
}: let
  script = pkgs.writeShellScript "ntfy-ssh" ''
    if [ "''${PAM_TYPE}" = "open_session" ]; then
      curl \
        -H "Title: Login ($(hostname))" \
        -H "Markdown: yes" \
        -d "SSH login to \`$(hostname)\`: \`''${PAM_USER}\` from \`''${PAM_RHOST}"\` \
        http://notify.adtailnet/logs
    fi
  '';
in {
  # Weird priority stuff to get the config to merge correctly, NixOS
  # really needs a better PAM module.
  security.pam.services.sshd.text = lib.mkDefault (lib.mkAfter ''
    session optional pam_exec.so ${script}
  '');
}
