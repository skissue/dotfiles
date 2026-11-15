{
  config,
  pkgs,
  self,
  inputs,
  private,
  mutable-link,
  ...
}: let
  sources = pkgs.callPackage "${self}/_sources/generated.nix" {};
  twistEnv = import ./twist.nix {inherit pkgs inputs sources;};
  emacs = twistEnv.emacsWrapper;
  compile = file: extraInputs:
    with pkgs;
      runCommandLocal "emacs-compile-${baseNameOf file}" {
        nativeBuildInputs = [emacs] ++ extraInputs;
      } ''
        cp ${file} input.el
        # Some packages are annoying and create directories in $HOME when
        # loaded. To deal with them, set home to this temporary build directory
        # so it doesn't error out.
        export HOME=$(pwd)
        emacs --batch \
          -f batch-byte-compile \
          input.el
        cp input.elc $out
      '';
  early-init = compile ./early-init.el [];
  # Git needed to load Magit at compile-time.
  init = compile ./config.el [pkgs.git];
  editor = pkgs.writeShellScript "editor" ''exec ${emacs}/bin/emacsclient "''${@:---create-frame}"'';
in {
  system.build.emacs-twist = twistEnv;
  users.users.${config.my.user.name}.packages = [emacs];

  hjem.users.${config.my.user.name} = {
    environment.sessionVariables = {
      EDITOR = editor;
      VISUAL = editor;
    };

    systemd.services.emacs = {
      description = "Emacs text editor";
      wantedBy = ["graphical-session.target"];
      after = ["graphical-session.target"];
      partOf = ["graphical-session.target"];
      # Without this the session PATH (aka installed packages) gets overridden
      enableDefaultPath = false;
      serviceConfig = {
        Type = "notify";
        ExecStart = "${emacs}/bin/emacs --fg-daemon";
        SuccessExitStatus = 15;
        Restart = "on-failure";
      };
    };

    xdg.config.files = {
      "emacs/early-init.el".source = ./early-init.el;
      "emacs/early-init.elc".source = early-init;
      "emacs/init.el".source = ./config.el;
      "emacs/init.elc".source = init;
      "emacs/user-lisp".source = inputs.elisp-extra;
      "emacs/private.json".text = builtins.toJSON private;
      "emacs/snippets".source = mutable-link ./snippets;
    };
    xdg.data.files."revealjs".source = sources.revealjs.src;
  };
}
