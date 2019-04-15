{ stdenv, fetchFromGitHub, autoreconfHook, docbook_xsl, docbook_xml_dtd_43, gtk-doc, icu
, libxslt, pkgconfig, python3 }:

let

  listVersion = "2019-03-29";
  listSources = fetchFromGitHub {
    sha256 = "14rv41qcxg8v1pjhmis59pahflp2ligk0s880add6hg5fdj4d8sm";
    rev = "826d762a078ae21cd8bb95fa8f38ae84bb3948e7";
    repo = "list";
    owner = "publicsuffix";
  };

  libVersion = "0.20.2";

in stdenv.mkDerivation rec {
  name = "libpsl-${version}";
  version = "${libVersion}-list-${listVersion}";

  src = fetchFromGitHub {
    sha256 = "0ijingxpnvl5xnna32j93ijagvjsvw2lhj71q39hz9xhzjzrda9b";
    rev = "libpsl-${libVersion}";
    repo = "libpsl";
    owner = "rockdaboot";
  };

  buildInputs = [ icu libxslt ];
  nativeBuildInputs = [ autoreconfHook docbook_xsl docbook_xml_dtd_43 gtk-doc pkgconfig python3 ];

  postPatch = ''
    substituteInPlace src/psl.c --replace bits/stat.h sys/stat.h
    patchShebangs src/psl-make-dafsa
  '';

  preAutoreconf = ''
    gtkdocize
  '';

  preConfigure = ''
    # The libpsl check phase requires the list's test scripts (tests/) as well
    cp -Rv "${listSources}"/* list
  '';
  configureFlags = [
    "--disable-builtin"
    "--disable-static"
    "--enable-gtk-doc"
    "--enable-man"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "C library for the Publix Suffix List";
    longDescription = ''
      libpsl is a C library for the Publix Suffix List (PSL). A "public suffix"
      is a domain name under which Internet users can directly register own
      names. Browsers and other web clients can use it to avoid privacy-leaking
      "supercookies" and "super domain" certificates, for highlighting parts of
      the domain in a user interface or sorting domain lists by site.
    '';
    homepage = http://rockdaboot.github.io/libpsl/;
    license = licenses.mit;
    platforms = with platforms; linux ++ darwin;
  };
}
