{ stdenv, fetchgit, autoreconfHook, pkgconfig, coreutils, readline80, python3Packages }:

let
  ell = fetchgit {
     url = https://git.kernel.org/pub/scm/libs/ell/ell.git;
     #rev = "0.17";
     rev = "48a369ec429b32740984b0be1092b43f2704c73e"; # 2019-03-70
     sha256 = "1vpf5r5w8k9i5qwsc4kzqlxsx2c1sjhrar2h4wks1axjxp3sx2jd";
  };
in stdenv.mkDerivation rec {
  pname = "iwd";

  #version = "0.14";
  version = "2019-03-14";

  src = fetchgit {
    url = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    rev = "5e95e30e41326b8decf7894fdafda5f64c4c2d4b";
    #rev = version;
    sha256 = "06ldw5855c08dgpcdf3snnrvkhzah8n17bnh94x5w3ba3kvjrw5w";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    python3Packages.wrapPython
  ];

  buildInputs = [
    readline80
    python3Packages.python
  ];

  pythonPath = [
    python3Packages.dbus-python
    python3Packages.pygobject3
  ];

  configureFlags = [
    "--with-dbus-datadir=${placeholder "out"}/etc/"
    "--with-dbus-busdir=${placeholder "out"}/share/dbus-1/system-services/"
    "--with-systemd-unitdir=${placeholder "out"}/lib/systemd/system/"
    "--with-systemd-modloaddir=${placeholder "out"}/etc/modules-load.d/" # maybe
    "--localstatedir=/var/"
    "--enable-wired"
  ];

  postUnpack = ''
    ln -s ${ell} ell
    patchShebangs .
  '';

  postInstall = ''
    cp -a test/* $out/bin/
    mkdir -p $out/share
    cp -a doc $out/share/
    cp -a README AUTHORS TODO $out/share/doc/
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/system-services/net.connman.ead.service \
                      --replace /bin/false ${coreutils}/bin/false
    substituteInPlace $out/share/dbus-1/system-services/net.connman.iwd.service \
                      --replace /bin/false ${coreutils}/bin/false
  '';

  meta = with stdenv.lib; {
    homepage = https://git.kernel.org/pub/scm/network/wireless/iwd.git;
    description = "Wireless daemon for Linux";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
