{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "mesos-dns-${version}";
  version = "0.1.2";
  rev = "v${version}";
  
  goPackagePath = "github.com/mesosphere/mesos-dns";

  # Avoid including the benchmarking test helper in the output:
  subPackages = [ "." ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/mesosphere/mesos-dns";
    sha256 = "0zs6lcgk43j7jp370qnii7n55cd9pa8gl56r8hy4nagfvlvrcm02";
  };

  goDeps = ./deps.json;
}
