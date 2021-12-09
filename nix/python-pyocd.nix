{ buildPythonPackage
, fetchPypi
, capstone
, cmsis-pack-manager
, colorama
, hidapi
, intelhex
, intervaltree
, naturalsort
, prettytable
, pyelftools
, pylink-square
, pyocd-pemicro
, pyusb
, pyyaml
, six
}:
let
  version = "0.32.1";
  pname = "pyocd";
in
buildPythonPackage {
  inherit pname version;
  doCheck = false;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-vmLJ3eb/zEOsE0yWklmWvOqTILx0Z0qtFhXQ5gmTW84=";
  };
  propagatedBuildInputs = [
    capstone
    cmsis-pack-manager
    colorama
    hidapi
    intelhex
    intervaltree
    naturalsort
    prettytable
    pyelftools
    pylink-square
    pyocd-pemicro
    pyusb
    pyyaml
    six
  ];
}
