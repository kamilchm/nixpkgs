{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "gosu-${version}";
  version = "1.9";

  goPackagePath = "github.com/tianon/gosu";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = version;
    sha256 = "1b1h1vxcmzhfpjj1flh81yw7f8gzxzwkzfw2qs77p333pidjl24g";
  };

  goDeps = ./deps.json;
}
