{
  epkgs,
  sources,
}: let
  inherit (epkgs) trivialBuild melpaBuild;
in {
  # Org Mode source with new async LaTeX preview support.
  # TODO Remove when this is merged.
  org = melpaBuild (sources.org-bleeding-latex
    // {
      pname = "org";
      version = "9.7.69";
      files = ''(:defaults "etc")'';
    });
  typst-ts-mode = trivialBuild sources.typst-ts-mode;
  copilot = epkgs.copilot.overrideAttrs (oldAttrs: {inherit (sources.copilot-el) src version;});
  org-popup-posframe = trivialBuild (sources.org-popup-posframe
    // rec {
      propagatedUserEnvPkgs = with epkgs; [posframe];
      buildInputs = propagatedUserEnvPkgs;
    });
  org-typst = trivialBuild sources.org-typst;
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
