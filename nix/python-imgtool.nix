{ buildPythonPackage, fetchPypi, cbor, click, cryptography, intelhex }:
let
  version = "1.7.2";
  pname = "imgtool";
in
buildPythonPackage {
  inherit pname version;
  doCheck = false;
  src = fetchPypi {
    inherit pname version;
    sha256 = "0vpdks8fg7dsjjb48xj18r70i95snq4z6j3m2p28lf8yyvrq953r";
  };
  propagatedBuildInputs = [
    cbor
    click
    cryptography
    intelhex
  ];
}
