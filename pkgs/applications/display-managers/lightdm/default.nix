{ stdenv, fetchFromGitHub, pam, pkgconfig, autoconf, automake, libtool, libxcb
, glib, libXdmcp, itstool, intltool, libxklavier, libgcrypt, audit, busybox
, polkit, accountsservice, gtk-doc, gnome3, gobject-introspection, vala, fetchpatch
, withQt4 ? false, qt4
, withQt5 ? false, qtbase
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "lightdm";
  version = "1.28.0";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "CanonicalLtd";
    repo = pname;
    #rev = version;
    rev = "66ceb790d8855dc2df754343d5eb8bbb780a3cd5";
    sha256 = "07xdd60w3y50m2fb3zaxi7glynppga4sggmj305jaa8z9ym8ylla";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gnome3.yelp-tools
    gnome3.yelp-xsl
    gobject-introspection
    gtk-doc
    intltool
    itstool
    libtool
    pkgconfig
    vala
  ];

  buildInputs = [
    accountsservice
    audit
    glib
    libXdmcp
    libgcrypt
    libxcb
    libxklavier
    pam
    polkit
  ] ++ optional withQt4 qt4
    ++ optional withQt5 qtbase;

  patches = [
    # Adds option to disable writing dmrc files
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/lightdm/raw/4cf0d2bed8d1c68970b0322ccd5dbbbb7a0b12bc/f/lightdm-1.25.1-disable_dmrc.patch";
      sha256 = "06f7iabagrsiws2l75sx2jyljknr9js7ydn151p3qfi104d1541n";
    })
  ];

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
    "--disable-static"
    "--disable-dmrc"
  ] ++ optional withQt4 "--enable-liblightdm-qt"
    ++ optional withQt5 "--enable-liblightdm-qt5";

  installFlags = [
    "sysconfdir=${placeholder ''out''}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  prePatch = ''
    substituteInPlace autogen.sh \
      --replace "which" "${busybox}/bin/which"

    substituteInPlace src/shared-data-manager.c \
      --replace /bin/rm ${busybox}/bin/rm
  '';

  meta = {
    homepage = https://github.com/CanonicalLtd/lightdm;
    description = "A cross-desktop display manager";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles worldofpeace ];
  };
}
