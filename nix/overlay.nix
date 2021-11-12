final: prior: {
  jlink = final.callPackage ./jlink.nix { };
  makeZephyrSdk = final.callPackage ./make-zephyr-sdk.nix { };
}
