{ stdenv, fetchFromGitHub, pkgconfig
, libdrm, libva, meson, ninja
}:

stdenv.mkDerivation rec {
  name = "libva-utils-${version}";
  inherit (libva) version;

  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva-utils";
    rev    = version;
    sha256 = "1yk9bg1wg4nqva3l01s6bghcvc3hb02gp62p1sy5qk0r9mn5kpik";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];

  buildInputs = [ libdrm libva ];

  mesonFlags = [
    "-Ddrm=true"
    "-Dx11=true"
    "-Dwayland=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "VAAPI tools: Video Acceleration API";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    maintainers = with maintainers; [ garbas ];
    platforms = platforms.unix;
  };
}
