{
  stdenvNoCC,
  my-sources-private,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "MonoLisa";
  version = "2.016";

  src = my-sources-private.monolisa;

  nativeBuildInputs = [unzip];

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp *.ttf $out

    runHook postInstall
  '';
}
