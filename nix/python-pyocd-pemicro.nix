{ buildPythonPackage
, fetchFromGitHub
, pypemicro
, setuptools
, setuptools-scm
, setuptools-scm-git-archive 
}:
let
  version = "1.0.6";
  pname = "pyocd-pemicro";
in
buildPythonPackage {
  inherit pname version;
  doCheck = false;
  src = fetchFromGitHub {
    owner = "pyocd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i/uLE+MYGNKa3V3FudMLYMfBK9r41tu5FvzwFoa1Oag=";
  };
  buildInputs = [
    setuptools
    setuptools-scm
    setuptools-scm-git-archive
  ];
  propagatedBuildInputs = [
    pypemicro
  ];
}
