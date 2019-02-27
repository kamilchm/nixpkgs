{ stdenv
, fetchFromGitLab
, pkgconfig
, intltool
, automake111x
, autoconf
, libtool
, gnome2
, libxslt
, python2
}:

let version = "unstable-2019-02-17";

in stdenv.mkDerivation {
  pname = "planner";
  inherit version;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "planner";
    rev = "84f9d481aa83d531e31c435014aeaad75e9f9e65";
    sha256 = "05mymy1yc0gi06ajqmm2l6n7n96s8r2gb4q6pvhb9jz51ywwdxir";
  };

  nativeBuildInputs = with gnome2; [
    pkgconfig
    intltool
    automake111x
    autoconf
    libtool
    gnome-common
    gtk-doc
    scrollkeeper
  ];

  buildInputs = with gnome2; [
    GConf
    gtk
    libgnomecanvas
    libgnomeui
    libglade
    libxslt
    python2
    python2.pkgs.pygtk
    #evolution-data-server
    #libsoup
  ];

  preConfigure = ''NOCONFIGURE=1 ./autogen.sh'';
  configureFlags = [
    "--enable-python"
    "--enable-python-plugin"
    #"--enable-eds"
  #  "--enable-eds-backend"
#    "--enable-simple-priority-scheduling"
    ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Planner;
    description = "Project management application for GNOME";
    longDescription = ''
      Planner is the GNOME project management tool.
      Its goal is to be an easy-to-use no-nonsense cross-platform
      project management application.

      Planner is a GTK+ application written in C and licensed under the
      GPLv2 or any later version. It can store its data in either xml
      files or in a postgresql database. Projects can also be printed
      to PDF or exported to HTML for easy viewing from any web browser.

      Planner was originally created by Richard Hult and Mikael Hallendal
      at Imendio.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ rasendubi amiloradovsky ];
  };
}
