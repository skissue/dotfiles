{
  epkgs,
  sources,
  inputs,
}: let
  inherit (epkgs) melpaBuild;
in {
  # Packages that depend on jsonrpc will pull in the ELPA version, which is
  # behind the one bundled with Emacs and breaks Eglot on the bleeding edge, so
  # disable it entirely.
  jsonrpc = null;

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
  inline-diff = melpaBuild (sources.inline-diff // {version = "0.0.1";});
  vertico-popup-frame = melpaBuild (sources.vertico-popup-frame
    // {
      version = "0.1.0";
      packageRequires = with epkgs; [vertico];
    });
  howm = melpaBuild (sources.howm
    // {
      version = "1.5.6";
    });
  elfin = melpaBuild (sources.elfin
    // {
      version = "0.0.1";
      packageRequires = with epkgs; [plz];
      files = ''(:defaults "extras")'';
    });
  modus-alabaster = melpaBuild (sources.modus-alabaster
    // {
      version = "0.0.1";
      packageRequires = with epkgs; [modus-themes];
    });
  funn = melpaBuild {
    pname = "funn";
    version = "0.1.0";
    src = inputs.funn;
    packageRequires = with epkgs; [posframe];
    files = ''("src/*.el")'';
  };
}
