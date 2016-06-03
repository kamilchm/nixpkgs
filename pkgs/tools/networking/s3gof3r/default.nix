# This file was generated by go2nix.
{ stdenv, lib, goPackages, fetchgit, fetchhg, fetchbzr, fetchsvn }:

with goPackages;

buildGoPackage rec {
  name = "s3gof3r-${version}";
  version = "20151109-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "31603a0dc94aefb822bfe2ceea75a6be6013b445";
  
  goPackagePath = "github.com/rlmcpherson/s3gof3r";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/rlmcpherson/s3gof3r";
    sha256 = "10banc8hnhxpsdmlkf9nc5fjkh1349bgpd9k7lggw3yih1rvmh7k";
  };

  goDeps = ./deps.json;
}
