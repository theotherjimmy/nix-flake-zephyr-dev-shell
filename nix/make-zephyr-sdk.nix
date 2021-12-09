{ stdenv, fetchurl, which, python38, autoPatchelfHook }: arch: hash:
let
  version = "0.13.2";
in
stdenv.mkDerivation {
  name = "zephyr-sdk";
  inherit version;
  src = fetchurl {
    url = "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${version}/zephyr-toolchain-${arch}-${version}-linux-x86_64-setup.run";
    inherit hash;
  };
  nativeBuildInputs = [
    which
    python38
    autoPatchelfHook
  ];
  # We can't do this in one  step, because the .run script
  # expects /bin/bash to exist. Instead, we break this up and this
  # seems to work fine.
  unpackPhase = "sh $src --noexec --target .";
  installPhase = "sh setup.sh -d $out -norc -nocmake -y";
}
