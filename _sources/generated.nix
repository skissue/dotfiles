# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  consult-mu = {
    pname = "consult-mu";
    version = "c4af472297e4daf65293c64684716f478d481469";
    src = fetchFromGitHub {
      owner = "armindarvish";
      repo = "consult-mu";
      rev = "c4af472297e4daf65293c64684716f478d481469";
      fetchSubmodules = false;
      sha256 = "sha256-lC70FB8NmDmIp+iPox78E4Z1u7E2r2vOrluiK4XBtbE=";
    };
    date = "2024-09-30";
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
    version = "3f9159a8b7fe87e2f01280a2c4c98ca6dab49d13";
    src = fetchFromGitHub {
      owner = "jdtsmith";
      repo = "eglot-booster";
      rev = "3f9159a8b7fe87e2f01280a2c4c98ca6dab49d13";
      fetchSubmodules = false;
      sha256 = "sha256-yRZci0foZUw2Thx1SwSoY0iPf2DmkAnRp6U+rdx1Bas=";
    };
    date = "2024-09-11";
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
    version = "a50a5700e876bc11d346b6518047904ca2e427f4";
    src = fetchFromGitHub {
      owner = "jdtsmith";
      repo = "indent-bars";
      rev = "a50a5700e876bc11d346b6518047904ca2e427f4";
      fetchSubmodules = false;
      sha256 = "sha256-T3Cybmg3P/9fRFNs3nGvhsBSkPGZIB2tGBcGYGliNAY=";
    };
    date = "2024-10-04";
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
    version = "11add1f4ac7f7956dc5aae98571605d27a1773e2";
    src = fetchFromGitHub {
      owner = "emacs-tree-sitter";
      repo = "treesit-fold";
      rev = "11add1f4ac7f7956dc5aae98571605d27a1773e2";
      fetchSubmodules = false;
      sha256 = "sha256-a3mQNkAqLdQTrcY2nP3Z/M526jDcXjcdMTeeayk3cJg=";
    };
    date = "2024-09-25";
  };
  typst-ts-mode = {
    pname = "typst-ts-mode";
    version = "a8487acfb74b93f76784651459e65e47f815cd67";
    src = fetchgit {
      url = "https://git.sr.ht/~meow_king/typst-ts-mode";
      rev = "a8487acfb74b93f76784651459e65e47f815cd67";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-C4BV+6wAheIMR5TRyPDwmLYx/z9TyZ4eLSiux/sPnGM=";
    };
    date = "2024-08-14";
  };
}
