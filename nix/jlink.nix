{ stdenv, autoPatchelfHook, libstdcxx5, xorg, freetype, fontconfig }:
stdenv.mkDerivation {
  name = "jlink";
  version = "750";
  src = ../JLink_Linux_V750_x86_64.tgz;
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
    stdenv.cc.cc
    freetype
    fontconfig
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXrandr
    xorg.libXrender
    xorg.libXext
    xorg.libXcursor
    xorg.libXfixes
  ];
  installPhase = ''
    mkdir -p $out/bin
    cp -r . $out/bin
  '';
};
