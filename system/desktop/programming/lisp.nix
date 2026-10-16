{
  config,
  pkgs,
  ...
}: {
  users.users.${config.my.user.name}.packages = with pkgs; [sbcl];

  hjem.users.${config.my.user.name}.files.".sbclrc".text = ''
    #-quicklisp
    (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                           (user-homedir-pathname))))
      (when (probe-file quicklisp-init)
        (load quicklisp-init)))
  '';
}
