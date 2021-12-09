{ buildPythonPackage
, fetchFromGitHub
, appdirs
, milksnake
, pyyaml
, rustPlatform
, setuptools
, setuptools-scm
, setuptools-scm-git-archive
}:
let
  version = "0.4.0";
  pname = "cmsis-pack-manager";
  src = fetchFromGitHub {
    owner = "pyocd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JP1B1Q3LKAjdLbr91EzWlK2EyfngBj0hsfc7dlj61es=";
  };
  cargoRoot = "rust";
in
buildPythonPackage {
  inherit pname version src cargoRoot;
  doCheck = false;
  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
  ];
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };
  patches = [ ./0001-Add-lock.patch ];
  propagatedBuildInputs = [
    appdirs
    milksnake
    pyyaml
    setuptools
    setuptools-scm
    setuptools-scm-git-archive
  ];
}
