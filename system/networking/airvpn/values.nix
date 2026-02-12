let
  excludeMark = 24242;
  wgMark = 22222;
in {
  inherit excludeMark wgMark;
  netconfName = "99-wg0";
  wgPriority = 50;
  excludeMarkS = toString excludeMark;
  wgMarkS = toString wgMark;
}
