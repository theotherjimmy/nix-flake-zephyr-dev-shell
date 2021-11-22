{ buildPythonPackage, fetchPypi, cbor, click, cryptography, intelhex }:
let
  version = "1.8.0";
  pname = "imgtool";
in
buildPythonPackage {
  inherit pname version;
  doCheck = false;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SFj1xfSM+koLuZ5g0AqikRcqfswq/k+3ftlhIfWbbi8=";
  };
  propagatedBuildInputs = [
    cbor
    click
    cryptography
    intelhex
  ];
}
