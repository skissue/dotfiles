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
    version = "f0c5f07b9ffe25d0deca42b650f6e0c1c85e9759";
    src = fetchFromGitHub {
      owner = "armindarvish";
      repo = "consult-omni";
      rev = "f0c5f07b9ffe25d0deca42b650f6e0c1c85e9759";
      fetchSubmodules = false;
      sha256 = "sha256-1+ES4Z7x53aZ7fGNKJ4uYuKHubaDpX3ro3XitGUDR+M=";
    };
    date = "2025-01-03";
  };
  copilot-el = {
    pname = "copilot-el";
    version = "be6c274562e150e4acf5253968d1b434c40d368b";
    src = fetchFromGitHub {
      owner = "zerolfx";
      repo = "copilot.el";
      rev = "be6c274562e150e4acf5253968d1b434c40d368b";
      fetchSubmodules = false;
      sha256 = "sha256-QYlFzh/rzIK0lTtj60rGxJtWr9JaGoVzfALeJltVOdU=";
    };
    date = "2025-01-05";
  };
  gptel-quick = {
    pname = "gptel-quick";
    version = "79c33058e605b4fbdb1d1f98d1ab428d6eed111d";
    src = fetchFromGitHub {
      owner = "karthink";
      repo = "gptel-quick";
      rev = "79c33058e605b4fbdb1d1f98d1ab428d6eed111d";
      fetchSubmodules = false;
      sha256 = "sha256-4ZhPL3+X83a4dfMZY7uclCLTBQESZCy4JKcw/6/8gy8=";
    };
    date = "2024-12-26";
  };
  mpv-skipsilence = {
    pname = "mpv-skipsilence";
    version = "5ae7c3b6f927e728c22fc13007265682d1ecf98c";
    src = fetchgit {
      url = "https://codeberg.org/ferreum/mpv-skipsilence";
      rev = "5ae7c3b6f927e728c22fc13007265682d1ecf98c";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-fg8vfeb68nr0bTBIvr0FnRnoB48/kV957pn22tWcz1g=";
    };
    date = "2024-05-06";
  };
  org-bleeding-latex = {
    pname = "org-bleeding-latex";
    version = "ce4a745b0aa746686376c5927b3165fe4cb4b4d7";
    src = fetchgit {
      url = "https://code.tecosaur.net/tec/org-mode.git";
      rev = "ce4a745b0aa746686376c5927b3165fe4cb4b4d7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-jotNr6F2AWzQv4XM931Hb3Imc3jCM1fVZe2+Y+YhJrg=";
    };
    date = "2024-12-29";
  };
  org-modern-indent = {
    pname = "org-modern-indent";
    version = "52b46c6ecd63e627ab5bfb83c580b51f68a23774";
    src = fetchFromGitHub {
      owner = "jdtsmith";
      repo = "org-modern-indent";
      rev = "52b46c6ecd63e627ab5bfb83c580b51f68a23774";
      fetchSubmodules = false;
      sha256 = "sha256-9aaaPGCvt51FknRKB5zT8AdHjhH/sQMc1IyQS3KnJsU=";
    };
    date = "2024-12-16";
  };
  org-overdrive = {
    pname = "org-overdrive";
    version = "1e0bb30195a8c807a7e092d1979b150aa7a1f9ef";
    src = fetchFromGitHub {
      owner = "skissue";
      repo = "org-overdrive";
      rev = "1e0bb30195a8c807a7e092d1979b150aa7a1f9ef";
      fetchSubmodules = false;
      sha256 = "sha256-K8TFR607A/vDUZz0v6wzW8WEdleOR4wM4vxWZe3/X3E=";
    };
    date = "2024-11-25";
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
  treesit-fold = {
    pname = "treesit-fold";
    version = "a40907676b705c7a1a51ef585b2db11e5021084b";
    src = fetchFromGitHub {
      owner = "emacs-tree-sitter";
      repo = "treesit-fold";
      rev = "a40907676b705c7a1a51ef585b2db11e5021084b";
      fetchSubmodules = false;
      sha256 = "sha256-wexgxD1Gdn+BN6DwME6qOUigj2N+ZXGlVoM8gJDNUpw=";
    };
    date = "2025-01-01";
  };
  typst-ts-mode = {
    pname = "typst-ts-mode";
    version = "1367003e2ad55a2f6f9e43178584683028ab56e9";
    src = fetchgit {
      url = "https://git.sr.ht/~meow_king/typst-ts-mode";
      rev = "1367003e2ad55a2f6f9e43178584683028ab56e9";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-0RAJ/Td3G7FDvzf7t8csNs/uc07WUPGvMo8ako5iyl0=";
    };
    date = "2024-12-07";
  };
}
