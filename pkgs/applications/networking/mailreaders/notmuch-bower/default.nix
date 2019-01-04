{ stdenv, fetchFromGitHub, gawk, mercury, pandoc, ncurses, gpgme }:

stdenv.mkDerivation rec {
  name = "notmuch-bower-${version}";
  #version = "0.9";
  version = "2019-01-04";

  src = fetchFromGitHub {
    owner = "wangp";
    repo = "bower";
    #rev = version;
    rev = "e8336b8e297d326c385d8ec0b71aa01e554a57ef";
    sha256 = "1hfk926sj7rxs0qaxdx3zdvgr3j414ghy0awa2zkr2l0il5zl81n";
  };

  nativeBuildInputs = [ gawk mercury pandoc ];

  buildInputs = [ ncurses gpgme ];

  preBuild = ''
    echo "MCFLAGS += --intermod-opt -O6 --verbose" > src/Mercury.params
  '';

  makeFlags = [ "PARALLEL=-j$(NIX_BUILD_CORES)" "bower" "man" ];

  patches = [
    #./0001-Use-some-emoticons-for-status.patch
    #./0002-Good-signature.patch
    #./0003-tick-for-selected.patch
    ./0004-convert-inbox-tag-to-single-char-indicator-hide-impo.patch
    ./0005-hide-more-tags-that-would-be-painful-to-mass-change.patch
    ./0006-lists.patch
    #./0007-tweak-icons-fix-spacing.patch
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv bower $out/bin/
    mkdir -p $out/share/man/man1
    mv bower.1 $out/share/man/man1/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/wangp/bower;
    description = "A curses terminal client for the Notmuch email system";
    maintainers = with maintainers; [ erictapen ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
