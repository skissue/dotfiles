org-mode

(s "#+begin_src " p n r> n "#+end_src"
   :post (org-edit-src-code))

(q "#+begin_quote" n r> n "#+end_quote")

nix-ts-mode

(shell "{pkgs ? import <nixpkgs> {}}:" n n
       "with pkgs;" n n>
       "mkShell {" n>
       "nativeBuildInputs = [" p "];" n>
       "buildInputs = [" p "];" n>
       "shellHook = ''" n>
       q n>
       "'';" n>
       "}")
