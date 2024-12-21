{
  epkgs,
  sources,
}: let
  trivialBuild = epkgs.trivialBuild;
in {
  typst-ts-mode = trivialBuild sources.typst-ts-mode;
  copilot-bleeding = epkgs.copilot.overrideAttrs (oldAttrs: {inherit (sources.copilot-el) src version;});
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
  org-overdrive = trivialBuild (sources.org-overdrive
    // rec {
      propagatedUserEnvPkgs = with epkgs; [asyncloop pcre2el request dash];
      buildInputs = propagatedUserEnvPkgs;
    });
}
