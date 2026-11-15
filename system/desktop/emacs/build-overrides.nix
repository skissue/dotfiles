# Based partly on https://github.com/emacs-twist/overrides
{
  pkgs,
  emacs,
}: _: super: {
  magit = super.magit.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [pkgs.git];
  });
  magit-todos = super.magit-todos.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [pkgs.git];
  });
  forge = super.forge.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [pkgs.git];
  });
  jinx = super.jinx.overrideAttrs (old: {
    nativeBuildInputs = [
      pkgs.gcc
      pkgs.pkg-config
    ];
    buildInputs = old.buildInputs ++ [pkgs.enchant_2];
    preBuild = ''
      NIX_CFLAGS_COMPILE="$($PKG_CONFIG --cflags enchant-2) $NIX_CFLAGS_COMPILE"
      $CC -I. -O2 -fPIC -shared -o jinx-mod${pkgs.stdenv.targetPlatform.extensions.sharedLibrary} jinx-mod.c -lenchant-2
      rm *.c *.h
    '';
  });
  auctex = super.auctex.overrideAttrs (_: {
    preBuild = ''export HOME="$TMPDIR"'';
    # The release archive already contains both compiled manuals.
    buildInfo = "";
    installInfo = ''
      install -Dm644 -t "$info/share/info" "$src/auctex.info" "$src/preview-latex.info"
    '';
  });
  geiser = super.geiser.overrideAttrs (_: {
    # Build the master document, not its standalone include fragments.
    buildInfo = ''
      makeinfo --no-split -I "$src/doc" "$src/doc/geiser.texi" -o geiser.info
    '';
  });
  pdf-tools = super.pdf-tools.overrideAttrs (old: {
    nativeBuildInputs = [
      pkgs.autoconf
      pkgs.automake
      pkgs.pkg-config
    ];
    buildInputs =
      old.buildInputs
      ++ [
        pkgs.libpng
        pkgs.zlib
        pkgs.poppler
      ];
    preBuild = ''
      make -C build server/epdfinfo
      cp build/server/epdfinfo .
    '';
    # Keep epdfinfo, not the native build tree, in the installed Lisp package.
    preInstall = ''rm -rf build'';
  });
  ghostel = super.ghostel.overrideAttrs (final: _: {
    nativeBuildInputs = [pkgs.zig_0_16];
    env.EMACS_INCLUDE_DIR = "${emacs}/include";

    zigDeps = pkgs.zig_0_16.fetchDeps {
      inherit (final) src version;
      pname = "ghostel";
      fetchAll = true;
      hash = "sha256-BZzOCIY/3kkpYN115YLeu8snFqW77cJBXF+z+cpNYLk=";
    };

    preBuild = ''
      export ZIG_GLOBAL_CACHE_DIR="$NIX_BUILD_TOP/.zig-global-cache"
      export ZIG_LOCAL_CACHE_DIR="$NIX_BUILD_TOP/.zig-local-cache"
      mkdir -p "$ZIG_GLOBAL_CACHE_DIR"
      cp -rLT "$zigDeps" "$ZIG_GLOBAL_CACHE_DIR/p"
      chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
      zig build -j$NIX_BUILD_CORES --prefix . -Dcpu=baseline -Doptimize=ReleaseFast
    '';

    # Twist installs this tree verbatim; retain only Lisp, the module and runtime assets.
    preInstall = ''
      rm -rf src vendor zig-pkg build.zig build.zig.zon symbols.map
    '';
  });
}
