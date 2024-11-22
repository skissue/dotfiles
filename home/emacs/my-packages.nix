{
  epkgs,
  sources,
}: let
  trivialBuild = epkgs.trivialBuild;
in {
  typst-ts-mode = trivialBuild sources.typst-ts-mode;
  copilot = trivialBuild (sources.copilot-el
    // rec {
      propagatedUserEnvPkgs = with epkgs; [s f dash editorconfig jsonrpc];
      buildInputs = propagatedUserEnvPkgs;
    });
  syncthing-el = trivialBuild sources.syncthing-el;
  eglot-booster = trivialBuild (sources.eglot-booster
    // rec {
      propagatedUserEnvPkgs = with epkgs; [jsonrpc eglot seq];
      buildInputs = propagatedUserEnvPkgs;
    });
  org-popup-posframe = trivialBuild (sources.org-popup-posframe
    // rec {
      propagatedUserEnvPkgs = with epkgs; [posframe];
      buildInputs = propagatedUserEnvPkgs;
    });
  org-typst = trivialBuild sources.org-typst;
  indent-bars = trivialBuild (sources.indent-bars
    // rec {
      propagatedUserEnvPkgs = with epkgs; [compat];
      buildInputs = propagatedUserEnvPkgs;
    });
  treesit-fold = trivialBuild sources.treesit-fold;
  gptel-quick = trivialBuild (sources.gptel-quick
    // rec {
      propagatedUserEnvPkgs = with epkgs; [compat gptel];
      buildInputs = propagatedUserEnvPkgs;
    });
  org-modern-indent = trivialBuild (sources.org-modern-indent
    // rec {
      propagatedUserEnvPkgs = with epkgs; [compat];
      buildInputs = propagatedUserEnvPkgs;
    });
  inline-anki = trivialBuild (sources.inline-anki
    // rec {
      propagatedUserEnvPkgs = with epkgs; [asyncloop pcre2el request dash];
      buildInputs = propagatedUserEnvPkgs;
    });
}
