# Woo, proprietary Electron garbage!
{
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  steam-run,
}:
let   
  version = "9";
 in
stdenv.mkDerivation {
  pname = "tetrio-desktop";
  inherit version;
  
  src = fetchurl {
    url = "https://tetr.io/about/desktop/builds/${version}/TETR.IO%20Setup.deb";
    hash = "sha256-UriLwMB8D+/T32H4rPbkJAy/F/FFhNpd++0AR1lwEfs=";
  };

  nativeBuildInputs = [dpkg makeWrapper];

  unpackCmd = "dpkg -x $curSrc unpacked";

  installPhase = ''
    mkdir -p $out/bin
    cp -r opt $out
    echo "${steam-run}/bin/steam-run $out/opt/TETR.IO/TETR.IO" > $out/bin/tetrio-desktop
    chmod +x $out/bin/tetrio-desktop
    cp -r usr/share $out
    substituteInPlace $out/share/applications/TETR.IO.desktop \
      --replace "/opt/TETR.IO/TETR.IO" "$out/bin/tetrio-desktop"
  '';
}
