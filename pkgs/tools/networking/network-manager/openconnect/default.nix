{ stdenv, fetchFromGitLab, substituteAll, openconnect, intltool, pkgconfig, autoreconfHook, networkmanager, gcr, libsecret, file
, gtk3, withGnome ? true, gnome3, kmod }:

let
  pname   = "NetworkManager-openconnect";
  version = "1.2.5.99"; # not really
in stdenv.mkDerivation rec {
  name    = "${pname}${if withGnome then "-gnome" else ""}-${version}";

  #src = fetchurl {
  #  url    = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
  #  sha256 = "15j98wwspv6mcmy91w30as5qc1bzsnhlk060xhjy4qrvd37y0xx1";
  #};
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "71618a98ee42b4cf680929b784e7abd751ff34c4";
    sha256 = "1hc852zascryxmp6nr25x44knhwlj82myh45rrfkn9mk9v6cr4q1";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit kmod openconnect;
    })
    #./can-persist.patch
    #./0001-Bug-770880-Revamp-certificate-warning-accept-dialog.patch
    #./0001-Bug-770880-Disallow-manual-cert-acceptance.patch
  ];

  buildInputs = [ openconnect networkmanager ]
    ++ stdenv.lib.optionals withGnome [ gtk3 gcr libsecret ];

  nativeBuildInputs = [ autoreconfHook /* autoreconf b/c patch configure.ac */ intltool pkgconfig file ];

  autoreconfPhase = ''./autogen.sh'';

  configureFlags = [
    "--with-gnome=${if withGnome then "yes" else "no"}"
    "--enable-absolute-paths"
    "--without-libnm-glib"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "networkmanager-openconnect";
    };
  };

  meta = with stdenv.lib; {
    description = "NetworkManager's OpenConnect plugin";
    inherit (networkmanager.meta) maintainers platforms;
    license = licenses.gpl2Plus;
  };
}
