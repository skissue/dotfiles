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
    // {
      packageRequires = with epkgs; [posframe];
    });
  org-typst = trivialBuild sources.org-typst;
  treesit-fold = trivialBuild sources.treesit-fold;
  gptel-quick = trivialBuild (sources.gptel-quick
    // {
      packageRequires = with epkgs; [compat gptel];
    });
  org-modern-indent = trivialBuild (sources.org-modern-indent
    // {
      packageRequires = with epkgs; [compat];
    });
  org-overdrive = trivialBuild (sources.org-overdrive
    // {
      packageRequires = with epkgs; [asyncloop pcre2el request dash];
    });
}
