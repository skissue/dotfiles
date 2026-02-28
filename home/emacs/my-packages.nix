{
  epkgs,
  sources,
}: let
  inherit (epkgs) melpaBuild;
in {
  # Packages that depend on jsonrpc will pull in the ELPA version, which is
  # behind the one bundled with Emacs and breaks Eglot on the bleeding edge, so
  # disable it entirely.
  jsonrpc = null;
  # Org Mode source with new async LaTeX preview support.
  # TODO Remove when this is merged.
  org = melpaBuild (sources.org-bleeding-latex
    // {
      pname = "org";
      version = "9.7.69";
      files = ''(:defaults "etc")'';
    });
  org-popup-posframe = melpaBuild (sources.org-popup-posframe
    // {
      version = "0.0.1";
      packageRequires = with epkgs; [posframe];
    });
  org-typst = melpaBuild (sources.org-typst // {version = "0.1.0";});
  gptel-quick = melpaBuild (sources.gptel-quick
    // {
      version = "0.0.5";
      packageRequires = with epkgs; [compat gptel];
    });
  gptel-openrouter-models = melpaBuild (sources.gptel-openrouter-models
    // {
      version = "1.0.0";
      files = ''(:defaults "openrouter-models.json")'';
    });
  org-modern-indent = melpaBuild (sources.org-modern-indent
    // {
      version = "0.1.4";
      packageRequires = with epkgs; [compat];
    });
  ultra-scroll = melpaBuild (sources.ultra-scroll // {version = "0.2.1";});
  inline-diff = melpaBuild (sources.inline-diff // {version = "0.0.1";});
  vertico-popup-frame = melpaBuild (sources.vertico-popup-frame
    // {
      version = "0.1.0";
      packageRequires = with epkgs; [vertico];
    });
  # YeeTube from the Codeberg mirror, because upstream has frequent downtime.
  yeetube = epkgs.yeetube.overrideAttrs (oldAttrs: {
    inherit (sources.yeetube-codeberg) src;
  });
}
