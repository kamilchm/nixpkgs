{ stdenv, lib, buildGoPackage, fetchgit }:

with builtins;

buildGoPackage rec {
  name = "gawp-${version}";
  version = "20160121-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "5db2d8faa220e8d6eaf8677354bd197bf621ff7f";
  
  goPackagePath = "github.com/martingallagher/gawp";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/martingallagher/gawp";
    sha256 = "0r4bp4w3s9rkmg3cz9jb7d6ngh7vfj31p9kbim6mhilxvmgjk4ly";
  };

  goDeps = ./deps.json;
}
