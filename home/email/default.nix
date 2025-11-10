{
  config,
  lib,
  pkgs,
  private,
  secretsDir,
  ...
}: let
  muIndex = "${lib.getExe config.programs.mu.package} index";

  mkAccount = name: address: options: {
    ${name} =
      {
        userName = address;
        inherit address;

        # https://github.com/nix-community/home-manager/pull/2916
        passwordCommand = toString (pkgs.writeShellScript "email-secret-${name}" "echo \"$(<${config.sops.secrets."email/${name}".path})\"");

        mbsync = {
          enable = true;
          create = "both";
          extraConfig.channel.ExpungeSolo = "both";
        };
        imapnotify = {
          enable = true;
          boxes = ["Inbox"];
          onNotify = "${lib.getExe config.programs.mbsync.package} --new --pull ${name}";
          onNotifyPost = "${muIndex}; ${pkgs.libnotify}/bin/notify-send 'New email!'";
        };

        mu.enable = true;
        msmtp.enable = true;
      }
      // options;
  };
in {
  sops.secrets = let
    accounts = builtins.attrNames config.accounts.email.accounts;
  in
    builtins.listToAttrs (map (n:
      lib.nameValuePair "email/${n}" {
        sopsFile = "${secretsDir}/desktop.yaml";
      })
    accounts);

  accounts.email = {
    maildirBasePath = "theuniverse/mail";
    accounts = mkAccount "mailbox" private.email.personal {
      primary = true;
      realName = "Ad";
      aliases = [private.email.public];

      imap.host = "imap.mailbox.org";
      smtp.host = "smtp.mailbox.org";
    };
  };

  programs = {
    mbsync.enable = true;
    mu.enable = true;
    msmtp.enable = true;
  };

  services = {
    mbsync = {
      enable = true;
      frequency = "*:0/10";
      postExec = muIndex;
    };
    imapnotify.enable = true;
  };
  systemd.user.services.mbsync.Unit.After = ["sops-nix.service"];
}
