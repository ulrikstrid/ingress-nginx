{ lib, buildGoModule }:

buildGoModule rec {
  name = "ingress-nginx-controller";
  version = "1.5.2-dev";
  src = ../.;

  env = {
    GOWORK = "off";
    PKG = "k8s.io/ingress-nginx";
    ARCH = "amd64";
    COMMIT_SHA = "7b4e4e2fa15f3d06e460c1b1c944a0c6a68f35e8";
    REPO_INFO = "https://github.com/stridtech/ingress-nginx";
    TAG = version;
  };

  vendorHash = "sha256-bBuOSOyE/tPsGlBv/3r3LF1ce5sdilRf8eIzUEkIIXE=";

  buildPhase = ''
    runHook preBuild
    
    ./build/build.sh
    
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp rootfs/bin/${env.ARCH}/* $out/bin

    runHook postInstall
  '';
}
