{
  stdenvNoCC,
  my-sources-private,
}:
stdenvNoCC.mkDerivation {
  pname = "PragmataPro";
  version = "0.830";

  src = my-sources-private.pragmatapro;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp *.ttf $out

    runHook postInstall
  '';
}
