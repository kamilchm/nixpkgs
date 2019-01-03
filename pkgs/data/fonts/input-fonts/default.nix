{ stdenv, requireFile, unzip }:

stdenv.mkDerivation rec {
  name = "input-fonts-${version}";
  version = "2017-08-10"; # date of the download and checksum

  src = requireFile {
    # round 'g'
    # slash zero
    name = "Input-Font-tweaks.zip";
    url = "http://input.fontbureau.com/download/";
    sha256 = "1kb4agq6q27hizk5q6issp1bh2j5aki67j6c20h57h0111p2izig";
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find Input_Fonts -name "*.ttf" -exec cp -a {} "$out"/share/fonts/truetype/ \;
    mkdir -p "$out"/share/doc
    cp -a *.txt "$out"/share/doc/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0jcgz1w0zrf981c66h1ga2f60kxiiwjc479vbdnczysyxlii0b6y";

  meta = with stdenv.lib; {
    description = "Fonts for Code, from Font Bureau";
    longDescription = ''
      Input is a font family designed for computer programming, data,
      and text composition. It was designed by David Jonathan Ross
      between 2012 and 2014 and published by The Font Bureau. It
      contains a wide array of styles so you can fine-tune the
      typography that works best in your editing environment.

      Input Mono is a monospaced typeface, where all characters occupy
      a fixed width. Input Sans and Serif are proportional typefaces
      that are designed with all of the features of a good monospace —
      generous spacing, large punctuation, and easily distinguishable
      characters — but without the limitations of a fixed width.
    '';
    homepage = http://input.fontbureau.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.all;
  };
}
