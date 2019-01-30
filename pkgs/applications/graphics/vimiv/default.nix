{ lib, python3Packages, fetchFromGitHub, imagemagick, librsvg, gtk3, jhead
, hicolor-icon-theme, defaultIconTheme, gobject-introspection, wrapGAppsHook

# Test requirements
, dbus, xvfb_run, xdotool
}:

python3Packages.buildPythonApplication rec {
  pname = "vimiv";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "karlch";
    repo = "vimiv";
    rev = "v${version}";
    sha256 = "1jq9s9nkfh6dzbpa68mf38hf2l4ks4g9kwsrliqhq2b41s9xhwkr";
  };

  testimages = fetchFromGitHub {
    owner = "karlch";
    repo = "vimiv";
    rev = "e5044ee9ec65ef5b7c601426ed3644a12952ff59";
    sha256 = "1la9vnmqs28rfgvvbhfh0ka4mzacfjbbyz2lw19xr8zl9bbai4wy";
  };

  postPatch = ''
    patchShebangs scripts/install_icons.sh
    sed -i -e 's,/usr,,g' -e '/setup\.py/d' Makefile scripts/install_icons.sh

    sed -i \
      -e 's,/etc/vimiv/\(vimivrc\|keys\.conf\),'"$out"'&,g' \
      man/* vimiv/config_parser.py

    substituteInPlace vimiv/helpers.py --replace /usr/share/man $out/share/man

    sed -i \
      -e 's!"mogrify"!"${imagemagick}/bin/mogrify"!g' \
      -e '/cmd *=/s!"jhead"!"${jhead}/bin/jhead"!g' \
      vimiv/imageactions.py
  '';

  checkInputs = [ python3Packages.nose dbus.daemon xvfb_run xdotool ];
  buildInputs = [ hicolor-icon-theme defaultIconTheme librsvg gobject-introspection wrapGAppsHook ];
  propagatedBuildInputs = with python3Packages; [ pillow pygobject3 gtk3 ];

  ##makeWrapperArgs = [
  ##  "--prefix GI_TYPELIB_PATH : \"$GI_TYPELIB_PATH\""
  ##  "--suffix XDG_DATA_DIRS : \"$XDG_ICON_DIRS:$out/share\""
  ##  "--set GDK_PIXBUF_MODULE_FILE \"$GDK_PIXBUF_MODULE_FILE\""
  ##];

  #postCheck = ''
  #  # Some tests assume that the directory only contains one vimiv directory
  #  rm -rf vimiv.egg-info vimiv.desktop

  #  # Re-use the wrapper args from the main program
  #  makeWrapper "$SHELL" run-tests $makeWrapperArgs

  #  cp -Rd --no-preserve=mode "$testimages/testimages" vimiv/testimages
  #  HOME="$(mktemp -d)" PATH="$out/bin:$PATH" \
  #    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
  #    --config-file=${dbus.daemon}/share/dbus-1/session.conf \
  #    ./run-tests -c 'python tests/main_test.py && nosetests -vx'
  #'';

  postInstall = ''
    make PREFIX= DESTDIR="${placeholder "out"}" install
  '';

  meta = {
    homepage = https://github.com/karlch/vimiv;
    description = "An image viewer with Vim-like keybindings";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
