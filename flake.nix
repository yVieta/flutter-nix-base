{
  description = "An example project using flutter";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };
      in {
        /* TODO FIX
        CMake Error at /nix/store/blqlkgmvs12h8m8rhbv7pmyj7jyxxp37-cmake-3.24.3/share/cmake-3.24/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
        Could NOT find PkgConfig (missing: PKG_CONFIG_EXECUTABLE)
        Call Stack (most recent call first):
        /nix/store/blqlkgmvs12h8m8rhbv7pmyj7jyxxp37-cmake-3.24.3/share/cmake-3.24/Modules/FindPackageHandleStandardArgs.cmake:594 (_FPHSA_FAILURE_MESSAGE)
        /nix/store/blqlkgmvs12h8m8rhbv7pmyj7jyxxp37-cmake-3.24.3/share/cmake-3.24/Modules/FindPkgConfig.cmake:99 (find_package_handle_standard_args)
        flutter/CMakeLists.txt:24 (find_package)
        */
        devShells.default =
          let android = pkgs.callPackage ./nix/android.nix { };
          in pkgs.mkShell {
            buildInputs = with pkgs; [
              # from pkgs
              python3Full
              cmake
              ninja
              clang
              flutter
              jdk11
              #from ./nix/*
              android.platform-tools
              libgtkflow3
            ];

            ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
            JAVA_HOME = pkgs.jdk11;
            ANDROID_AVD_HOME = (toString ./.) + "/.android/avd";

          };
      });
}
