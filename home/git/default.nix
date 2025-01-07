{
  config,
  lib,
  private,
  ...
}: {
  programs.git = {
    enable = true;
    difftastic.enable = true;

    userName = "Ad";
    userEmail = "me@skissue.xyz";

    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";

      sendemail.sendmailCmd = lib.getExe config.programs.msmtp.package;

      transfer.fsckobjects = true;
      fetch.fsckobjects = true;
      receive.fsckobjects = true;

      github.user = "skissue";
    };

    ignores = [
      "/.direnv"
      "/.envrc"
    ];

    includes = [
      {
        condition = "hasconfig:remote.*.url:*gh-work:*/**";
        contents = {
          user = {
            inherit (private) name;
            email = private.email.work;
          };
          github.user = private.user.work;
        };
      }
    ];
  };

  programs.ssh.matchBlocks = {
    "gh-skissue" = {
      user = "git";
      hostname = "github.com";
      identityFile = "~/.ssh/skissue";
    };
    "cb-skissue" = {
      user = "git";
      hostname = "codeberg.org";
      identityFile = "~/.ssh/skissue";
    };
    "gl-skissue" = {
      user = "git";
      hostname = "gitlab.com";
      identityFile = "~/.ssh/skissue";
    };
    "gh-work" = {
      user = "git";
      hostname = "github.com";
      identityFile = "~/.ssh/work";
    };
  };

  home.shellAliases = {
    g = "git";
    gs = "git status";
    gl = "git log";
    gp = "git pull";
    gpu = "git push";
  };
}
