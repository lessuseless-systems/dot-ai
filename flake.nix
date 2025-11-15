{
  description = "A-Layer: Pure Nix+Nickel agent orchestration library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nickel.url = "github:tweag/nickel";
  };

  outputs = { self, nixpkgs, flake-utils, nickel }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nickelPkg = nickel.packages.${system}.default;

        # Import our library modules
        lib = import ./nix/lib { inherit pkgs nickelPkg; };

      in {
        # Library API for Nix imports
        lib = lib;

        # CLI application
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.a-layer-cli}/bin/a-layer";
        };

        # Packages
        packages = {
          # CLI package
          a-layer-cli = pkgs.writeScriptBin "a-layer" ''
            #!${pkgs.bash}/bin/bash
            ${pkgs.nickel}/bin/nickel eval ${./nix/cli/main.nix} "$@"
          '';

          default = self.packages.${system}.a-layer-cli;
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          packages = [
            nickelPkg
            pkgs.nixpkgs-fmt
            pkgs.git
            pkgs.jq
          ];

          shellHook = ''
            echo "A-Layer development environment"
            echo "Nickel version: $(nickel --version)"
            echo ""
            echo "Try: nix run . -- plan examples/simple-agent.ncl"
          '';
        };
      });
}
