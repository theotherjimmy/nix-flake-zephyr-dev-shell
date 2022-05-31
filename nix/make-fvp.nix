{ lib, stdenv, fetchurl, which, python38, autoPatchelfHook, pango, gtk2-x11 }:
let
  version = "11.17_23";
in
stdenv.mkDerivation {
  name = "fvp-corestone-1000";
  inherit version;
  src =  fetchurl {
    url = "https://developer.arm.com/-/media/Arm%20Developer%20Community/Downloads/OSS/FVP/Corstone-1000-23/Linux/FVP_Corstone_1000_${version}.tgz";
    hash = "sha256-AMy3LQLJDiQk0kpiXSdcq/jqjcAkcTmFII9hi7iNGTQ=";
  };
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    pango
    gtk2-x11
  ];
  unpackPhase = "tar xf $src";
  installPhase = "mkdir $out; tail -c +49483 FVP_Corstone_1000.sh | tar xz -C $out";
}
