{ stdenv, lib, libpcap, buildGoPackage, fetchFromGitHub }:

with lib;

buildGoPackage rec {
  name = "etcd-${version}";
  version = "3.1.3"; # After updating check that nixos tests pass
  rev = "v${version}";

  goPackagePath = "github.com/coreos/etcd";

  subPackages = [ "cmd/etcd" "cmd/etcdctl" "cmd/tools/benchmark"
    "cmd/tools/etcd-dump-db" "cmd/tools/etcd-dump-logs" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "coreos";
    repo = "etcd";
    sha256 = "0jilkh90sr40iryc8l7b95f92whf23gh19a7ia4vi0lmyidkd45i";
  };

  buildInputs = [ libpcap ];

  meta = {
    description = "Distributed reliable key-value store for the most critical data of a distributed system";
    license = licenses.asl20;
    homepage = https://coreos.com/etcd/;
    maintainers = with maintainers; [offline];
    platforms = with platforms; linux;
  };
}
