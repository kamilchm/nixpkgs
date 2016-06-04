# This file was generated by go2nix.
{ stdenv, lib, libpcap, goPackages, fetchgit, fetchhg, fetchbzr, fetchsvn }:

with goPackages;

buildGoPackage rec {
  name = "etcd-${version}";
  version = "2.3.0";
  rev = "v${version}";
  
  goPackagePath = "github.com/coreos/etcd";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/coreos/etcd";
    sha256 = "1cchlhsdbbqal145cvdiq7rzqqi131iq7z0r2hmzwx414k04wyn7";
  };

  goDeps = ./deps.json;

  buildInputs = [ libpcap ];
}
