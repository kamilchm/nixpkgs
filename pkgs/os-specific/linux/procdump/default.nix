{ stdenv, fetchFromGitHub, bash, coreutils, gdb, zlib }:

stdenv.mkDerivation rec {
  name = "procdump-${version}";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "ProcDump-for-Linux";
    rev = version;
    sha256 = "1lkm05hq4hl1vadj9ifm18hi7cbf5045xlfxdfbrpsl6kxgfwcc4";
  };

  nativeBuildInputs = [ zlib ];
  buildInputs = [ bash coreutils gdb ];

  postPatch = ''
    substituteInPlace src/ProcDumpConfiguration.c \
      --replace " sigset;" " signalset;" \
      --replace "&sigset" "&signalset"

    substituteInPlace src/CoreDumpWriter.c \
      --replace '"gcore ' \
                '"${gdb}/bin/gcore ' \
      --replace '"rm ' '"${coreutils}/bin/rm ' \
      --replace /bin/bash ${bash}/bin/bash
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "INSTALLDIR=/bin"
    "MANDIR=/share/man/man1"
  ];

  doCheck = false; # needs root

  meta = with stdenv.lib; {
    description = "A Linux version of the ProcDump Sysinternals tool";
    homepage = https://github.com/Microsoft/ProcDump-for-Linux;
    license = licenses.mit;
    maintainers = with maintainers; [ c0bw3b ];
    platforms = platforms.linux;
  };
}
