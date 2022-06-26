{ lib, fetchzip, buildPythonApplication, python3Packages
  , desktop-file-utils, freecell-solver }:

buildPythonApplication rec {
  pname = "PySolFC";
  version = "2.16.0";

  src = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC/PySolFC-${version}/PySolFC-${version}.tar.xz";
    sha256 = "0fc819d28e2b14b84ff4f86b6983557d3e2b4353e19815724e4daeded3463774";
  };

  cardsets = fetchzip {
    url = "https://versaweb.dl.sourceforge.net/project/pysolfc/PySolFC-Cardsets/PySolFC-Cardsets-2.1/PySolFC-Cardsets-2.1.tar.bz2";
    sha256 = "0fc819d28e2b14b84ff4f86b6983557d3e2b4353e19815724e4daeded3463774";
  };

  propagatedBuildInputs = with python3Packages; [
    tkinter six random2 configobj 
    # optional :
    pygame freecell-solver pillow
  ];

  patches = [
    ./pysolfc-datadir.patch
  ];

  nativeBuildInputs = [ desktop-file-utils ];
  postPatch = ''
    desktop-file-edit --set-key Icon --set-value ${placeholder "out"}/share/icons/pysol01.png data/pysol.desktop
    desktop-file-edit --set-key Comment --set-value "${meta.description}" data/pysol.desktop
  '';

  postInstall = ''
    mkdir $out/share/PySolFC/cardsets
    cp -r $cardsets/* $out/share/PySolFC/cardsets
  '';

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    description = "A collection of more than 1000 solitaire card games";
    homepage = "https://pysolfc.sourceforge.io";
    license = licenses.gpl3;
    maintainers = with maintainers; [ kierdavis ];
  };
}
