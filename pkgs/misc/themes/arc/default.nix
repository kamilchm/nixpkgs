{ stdenv, fetchFromGitHub, sassc, autoreconfHook, pkgconfig, gtk3, gnome3
, gtk-engine-murrine, optipng, inkscape }:

let
  pname = "arc-theme";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  version = "20190129";

  src = fetchFromGitHub {
    owner  = "NicoHood";
    repo   = pname;
    rev    = "2bac3c1a8fd5db058b031b4f2d45f5098462d65e";
    sha256 = "17i0yqwmp5bhzji81z0w2mmib2ik20khw33ax3aqzrqigd4xvnbc";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
    sassc
    optipng
    inkscape
    gtk3
    gnome3.gnome-shell
  ];

  propagatedUserEnvPkgs = [
    gnome3.gnome-themes-extra
    gtk-engine-murrine
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
  '';

  preBuild = ''
    # Shut up inkscape's warnings about creating profile directory
    export HOME="$NIX_BUILD_ROOT"
  '';

  configureFlags = [ "--disable-unity" ];

  postInstall = ''
    install -Dm644 -t $out/share/doc/${pname} AUTHORS *.md
  '';

  meta = with stdenv.lib; {
    description = "A flat theme with transparent elements for GTK 3, GTK 2 and Gnome-Shell";
    homepage    = https://github.com/NicoHood/arc-theme;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ simonvandel romildo ];
    platforms   = platforms.linux;
  };
}
