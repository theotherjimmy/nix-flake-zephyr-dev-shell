{
  description = "A Zephyr dev shell";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils/master";
    devshell.url = "github:numtide/devshell/master";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, devshell }:
    let
      local-pythonpkgs = ".pythonpkgs";
      mkZephyrShell = pkgs:
        let
          zephyr-sdk-arm = pkgs.makeZephyrSdk
            "arm" "sha256-D4CI4hgipnJwy9OPxurGA9PH0b7g0XhsygPrvlXOzFo=";
          zephyr-sdk-x64 = pkgs.makeZephyrSdk
            "x86_64" "sha256-8e9fhtnFA/03YOqbYa8do+JNzxfOYpeoVtA/XchJmoo=";
          zephyr-sdk = pkgs.symlinkJoin {
            name = "Zephyr-SDK";
            paths = [
              zephyr-sdk-arm
              zephyr-sdk-x64
            ];
          };
          python-packages = pkgs.python3.withPackages (p: builtins.attrValues {
            inherit (p)
              pyelftools
              pyyaml
              pykwalify
              canopen
              packaging
              progress
              psutil
              anytree
              west
              cryptography
              intelhex
              click
              cbor
              jinja2
              # imgtool -- mcuboot's imagetool
              pyocd
              pip
              pyusb
              #twister deps
              ply
              pyserial
              tabulate
              GitPython
              # check copliance deps
              junitparser
              magic;
            # TODO: find a way to add this to the overlay
            imgtool = (p.callPackage ./nix/python-imgtool.nix { });
          });
          zephyr-cmake = pkgs.cmake.overrideAttrs (old:
            let
              version = "3.21.2";
            in
            {
              inherit version;
              patches = [ ];
              src = pkgs.fetchurl {
                url = "https://cmake.org/files/v${pkgs.lib.versions.majorMinor version}/cmake-${version}.tar.gz";
                # compare with https://cmake.org/files/v${lib.versions.majorMinor version}/cmake-${version}-SHA-256.txt
                sha256 = "sha256-lCdeC2HIS7QnEPUyCiPG3LLG7gMq59KmFvU/aLPSFlk=";
              };
            });
        in
        pkgs.devshell.mkShell {
          motd = "";
          packages = builtins.attrValues {
            inherit
              python-packages
              zephyr-sdk
              zephyr-cmake;
            inherit (pkgs)
              uncrustify
              gitlint
              openssl
              tshark
              binutils
              gcc-arm-embedded
              ninja
              gperf
              ccache
              dtc
              gnumake
              # For mcuboot development, we want both Rust and go.
              go
              pkgconfig
              mbedtls
              cargo
              cargo-deps
              # debug utilities
              gdb-multitarget
              openocd
              libusb
              libusb-compat-0_1
              # rust
              cargo-watch
              cargo-binutils
              rustc
              # crud for "native" zephyr sockets
              glib
              libpcap
              libtool
              automake
              autoconf
              socat
              bridge-utils;
            inherit (pkgs.stdenv) cc;
            inherit (pkgs.unixtools) xxd;
            openssl-dev = pkgs.openssl.dev;
            sqlite-dev = pkgs.sqlite.dev;
          };
          env = [
            { name = "ZEPHYR_SDK_INSTALL_DIR"; value = "${zephyr-sdk}"; }
            { name = "PYTHONPATH"; eval = "${python-packages}/lib/python3.9/site-packages:$PYTHONPATH"; }
            # NOTE: I'm using the PIP_TARGET below to work around the fact
            # that I can't install pyocd through nixpkgs at this time. Remove
            # this when I find a way to install pyocd through nixpkgs.
            { name = "PIP_TARGET"; value = local-pythonpkgs; }
            { name = "LD_LIBRARY_PATH"; eval = "${pkgs.libusb-compat-0_1}/lib:$LD_LIBRARY_PATH"; }
          ];
        };
    in
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = mkZephyrShell (import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlay
          (import ./nix/overlay.nix)
        ];
      });
    });
}

