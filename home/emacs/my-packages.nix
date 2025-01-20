{
  epkgs,
  sources,
}: let
  inherit (epkgs) melpaBuild;
in {
  # Org Mode source with new async LaTeX preview support.
  # TODO Remove when this is merged.
  org = melpaBuild (sources.org-bleeding-latex
    // {
      pname = "org";
      version = "9.7.69";
      files = ''(:defaults "etc")'';
    });
  # gptel with support for tool-use.
  # TODO Remove when this is merged.
  gptel = epkgs.gptel.overrideAttrs (oldAttrs: {inherit (sources.gptel-tooluse) src;});
  typst-ts-mode = melpaBuild (sources.typst-ts-mode // {version = "0.10.0";});
  org-popup-posframe = melpaBuild (sources.org-popup-posframe
    // {
      version = "0.0.1";
      packageRequires = with epkgs; [posframe];
    });
  org-typst = melpaBuild (sources.org-typst // {version = "0.1.0";});
  treesit-fold = melpaBuild (sources.treesit-fold // {version = "0.1.0";});
  gptel-quick = melpaBuild (sources.gptel-quick
    // {
      version = "0.0.5";
      packageRequires = with epkgs; [compat gptel];
    });
  org-modern-indent = melpaBuild (sources.org-modern-indent
    // {
      version = "0.1.4";
      packageRequires = with epkgs; [compat];
    });
  org-overdrive = melpaBuild (sources.org-overdrive
    // {
      version = "0.1.0";
      packageRequires = with epkgs; [asyncloop pcre2el request dash];
    });
  ultra-scroll = melpaBuild (sources.ultra-scroll // {version = "0.2.1";});
  inline-diff = melpaBuild (sources.inline-diff // {version = "0.0.1";});
}
