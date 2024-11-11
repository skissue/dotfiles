# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  consult-mu = {
    pname = "consult-mu";
    version = "90db1c6e3d0ec16126a347f6c15426c2a8ce0125";
    src = fetchFromGitHub {
      owner = "armindarvish";
      repo = "consult-mu";
      rev = "90db1c6e3d0ec16126a347f6c15426c2a8ce0125";
      fetchSubmodules = false;
      sha256 = "sha256-slq53y7Hn6rZtPMhiUnS1rHmdE300ACW343dsY3u+Vg=";
    };
    date = "2024-10-16";
  };
  consult-omni = {
    pname = "consult-omni";
    version = "87b5bcf0e55c01e6a4a24ae74ce691f55d1455a2";
    src = fetchFromGitHub {
      owner = "armindarvish";
      repo = "consult-omni";
      rev = "87b5bcf0e55c01e6a4a24ae74ce691f55d1455a2";
      fetchSubmodules = false;
      sha256 = "sha256-x5rNTNEDLoHzIlA1y+VsQ+Y0Pa1QXbybt2rIUBJ+VtM=";
    };
    date = "2024-09-27";
  };
  copilot-el = {
    pname = "copilot-el";
    version = "b5878d6a8c741138b5efbf4fe1c594f3fd69dbdd";
    src = fetchFromGitHub {
      owner = "zerolfx";
      repo = "copilot.el";
      rev = "b5878d6a8c741138b5efbf4fe1c594f3fd69dbdd";
      fetchSubmodules = false;
      sha256 = "sha256-02ywlMPku1FIritZjjtxbQW6MmPvSwmRCrudYsUb8bU=";
    };
    date = "2024-09-25";
  };
  doom-snippets = {
    pname = "doom-snippets";
    version = "b672e69bbf5623e8af0fed27b23a1093fa217315";
    src = fetchFromGitHub {
      owner = "doomemacs";
      repo = "snippets";
      rev = "b672e69bbf5623e8af0fed27b23a1093fa217315";
      fetchSubmodules = false;
      sha256 = "sha256-t0jgXdfO5V/u5GOd1tkXGtgeTiezu6/NOK8IhkH6WY0=";
    };
    date = "2024-08-09";
  };
  eglot-booster = {
    pname = "eglot-booster";
    version = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
    src = fetchFromGitHub {
      owner = "jdtsmith";
      repo = "eglot-booster";
      rev = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
      fetchSubmodules = false;
      sha256 = "sha256-PLfaXELkdX5NZcSmR1s/kgmU16ODF8bn56nfTh9g6bs=";
    };
    date = "2024-10-29";
  };
  gptel-quick = {
    pname = "gptel-quick";
    version = "54f1c65b416b5a9c93640f6d2ed86734b9ae1336";
    src = fetchFromGitHub {
      owner = "karthink";
      repo = "gptel-quick";
      rev = "54f1c65b416b5a9c93640f6d2ed86734b9ae1336";
      fetchSubmodules = false;
      sha256 = "sha256-ZAx8MQNdBR+n8hTZUh+eGmVJfcGu46q9d71++NzisAg=";
    };
    date = "2024-09-09";
  };
  indent-bars = {
    pname = "indent-bars";
    version = "f860825f24710438b8dd95f36fdee892ffb2a245";
    src = fetchFromGitHub {
      owner = "jdtsmith";
      repo = "indent-bars";
      rev = "f860825f24710438b8dd95f36fdee892ffb2a245";
      fetchSubmodules = false;
      sha256 = "sha256-W9PCSgnkVzM6X10PGbJyPe+WZEv3AXsg9bXctv2XRTM=";
    };
    date = "2024-11-09";
  };
  org-modern-indent = {
    pname = "org-modern-indent";
    version = "37939645552668f0f79a76c9eccc5654f6a3ee6c";
    src = fetchFromGitHub {
      owner = "jdtsmith";
      repo = "org-modern-indent";
      rev = "37939645552668f0f79a76c9eccc5654f6a3ee6c";
      fetchSubmodules = false;
      sha256 = "sha256-fnaWLnXfVpPB3ggQOqLSl/ykHfrJbwdoLdFwInHmg1U=";
    };
    date = "2024-11-05";
  };
  org-popup-posframe = {
    pname = "org-popup-posframe";
    version = "d39cb7c2c9a996689b0d6519695eed3d807c0c85";
    src = fetchFromGitHub {
      owner = "A7R7";
      repo = "org-popup-posframe";
      rev = "d39cb7c2c9a996689b0d6519695eed3d807c0c85";
      fetchSubmodules = false;
      sha256 = "sha256-yZJBx/uJ9W9ZAdYieZ7ArRvigt0391rIyTt+DEIHHjU=";
    };
    date = "2024-05-28";
  };
  org-typst = {
    pname = "org-typst";
    version = "367f23c9db3c80f75be6c407470ba71d5c34f709";
    src = fetchFromGitHub {
      owner = "skissue";
      repo = "org-typst";
      rev = "367f23c9db3c80f75be6c407470ba71d5c34f709";
      fetchSubmodules = false;
      sha256 = "sha256-ynuUyRdZRvmUq/zejkGyZSpHDKd7R34olAfqMoqU7Ic=";
    };
    date = "2024-05-10";
  };
  revealjs = {
    pname = "revealjs";
    version = "5.1.0";
    src = fetchFromGitHub {
      owner = "hakimel";
      repo = "reveal.js";
      rev = "5.1.0";
      fetchSubmodules = false;
      sha256 = "sha256-L6KVBw20K67lHT07Ws+ZC2DwdURahqyuyjAaK0kTgN0=";
    };
  };
  syncthing-el = {
    pname = "syncthing-el";
    version = "2.2.0";
    src = fetchFromGitHub {
      owner = "KeyWeeUsr";
      repo = "emacs-syncthing";
      rev = "2.2.0";
      fetchSubmodules = false;
      sha256 = "sha256-F2f0QH18MijQ4mLd7/0bftVqi1EQDA0RMuEV16V9Ro8=";
    };
  };
  treesit-fold = {
    pname = "treesit-fold";
    version = "25d0a231e0fc477ef77dfcd446d50682430c714e";
    src = fetchFromGitHub {
      owner = "emacs-tree-sitter";
      repo = "treesit-fold";
      rev = "25d0a231e0fc477ef77dfcd446d50682430c714e";
      fetchSubmodules = false;
      sha256 = "sha256-iu4dcJ/sOeHqM+jkTywwrtYA5EicQlf5cX4AuqMIhAM=";
    };
    date = "2024-10-31";
  };
  typst-ts-mode = {
    pname = "typst-ts-mode";
    version = "42094eb2508f30ca2aba26786768e969476d98fa";
    src = fetchgit {
      url = "https://git.sr.ht/~meow_king/typst-ts-mode";
      rev = "42094eb2508f30ca2aba26786768e969476d98fa";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-KYIu7nOhfeNoypOleFXzKiUm9yF/6MFQXUZllSyDiKw=";
    };
    date = "2024-10-12";
  };
}
