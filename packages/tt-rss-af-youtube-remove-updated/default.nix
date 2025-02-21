{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "tt-rss-af-youtube-auth-ldap";
  version = "unstable-2021-08-15";

  src = fetchFromGitHub {
    owner = "sal0max";
    repo = "ttrss-af_youtube_remove_updated";
    rev = "01b5b0a541237cff0af2bb9644da1d5393a69f20";
    sha256 = "sha256-1XrX4kXJ5QVawS9mj3RIZODAAdeyv3Y4up0tT8C+8bk=";
  };

  installPhase = ''
    install -D init.php $out/af_youtube_remove_updated/init.php
  '';
}
