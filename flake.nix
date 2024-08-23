{
  inputs = {
    nix2container.url = "github:nlewo/nix2container";
    nix2container.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      nix2container,
      self,
    }:
    let
      allSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      # A function that provides a system-specific Nixpkgs for the desired systems
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs allSystems (
          system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
            nix2containerPkgs = nix2container.packages.${system};
          }
        );
    in
    {
      packages = forAllSystems (
        { pkgs, system, nix2containerPkgs, ... }:
        rec {
          default = controller;
          controller = pkgs.callPackage ./nix {};
        }
      );

      devShells = forAllSystems (
        { pkgs, system, ... }:
        {
        }
      );
    };
}
