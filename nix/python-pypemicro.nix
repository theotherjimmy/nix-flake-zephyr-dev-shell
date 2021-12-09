{ buildPythonPackage, fetchPypi }:
let
  version = "0.1.7";
  pname = "pypemicro";
in
buildPythonPackage {
  inherit pname version;
  doCheck = false;
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G2RXDhXy7IGcrEMVQrsT14nb2KhC5QQrmF4lhe1iDgU=";
  };
}
