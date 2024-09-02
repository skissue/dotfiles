{pkgs, ...}: {
  home.packages = with pkgs; [sbcl];

  home.file.".sbclrc".text = ''
    #-quicklisp
    (let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                           (user-homedir-pathname))))
      (when (probe-file quicklisp-init)
        (load quicklisp-init)))
  '';
}
