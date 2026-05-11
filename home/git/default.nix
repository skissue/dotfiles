{
  config,
  lib,
  private,
  ...
}: {
  programs.git = {
    enable = true;

    signing.format = "ssh";

    settings = {
      user = {
        name = "Ad";
        email = "me@skissue.xyz";
      };

      init.defaultBranch = "main";
      merge.conflictstyle = "zdiff3";
      diff.algorithm = "histogram";

      fetch.prune = true;
      pull.rebase = true;
      merge.ff = "only";
      push.followTags = true;

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
    "gh-work" = {
      user = "git";
      hostname = "github.com";
      identityFile = "~/.ssh/work";
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };
}
