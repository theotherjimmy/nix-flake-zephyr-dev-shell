final: prior: {
  jlink = final.callPackage ./jlink.nix { };
  makeZephyrSdk = final.callPackage ./make-zephyr-sdk.nix { };
  fvpCorestone = final.callPackage ./make-fvp.nix { };
  python3 = prior.python3.override {
    packageOverrides = pyfinal: pyprior: {
      cmsis-pack-manager = pyfinal.callPackage ./python-cmsis-pack-manager.nix { };
      pyocd = pyfinal.callPackage ./python-pyocd.nix { };
      pyocd-pemicro = pyfinal.callPackage ./python-pyocd-pemicro.nix { };
      pypemicro = pyfinal.callPackage ./python-pypemicro.nix { };
      pylink-square = pyprior.pylink-square.overrideAttrs (old: let
        version = "0.11.1";
      in
      {
        name = "${old.pname}-${version}";
        src = final.fetchFromGitHub {
          owner = "square";
          repo = "pylink";
          rev = "v${version}";
          sha256 = "sha256-F7K4Zul0Jb9K8te017X8odIOsG3MpPRvklbEMP8f3GM=";
        };
      });
      pyyaml = let 
        pname = "pyyaml";
        version = "6.0";
      in
      pyfinal.buildPythonPackage {
        inherit pname version;
        src = final.fetchFromGitHub {
          owner = "yaml";
          repo = pname;
          rev = version;
          sha256 = "sha256-wcII32mRgRRmAgojntyxBMQkjvxU2jylCgVzlHAj2Xc=";
        };
      };
    };
  };
}
