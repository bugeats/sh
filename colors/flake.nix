{
  inputs.systems.url = "github:nix-systems/default";
  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
  outputs =
    {
      self,
      systems,
      nixpkgs,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);

      common = eachSystem (system: {
        buildInputs = with nixpkgs.legacyPackages.${system}; [
          (python3.withPackages (
            ps: with ps; [
              hsluv
              numpy
              typing-extensions
              scipy
            ]
          ))
          self.packages.${system}.colour-science
        ];
      });
    in
    {
      packages = eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.stdenv.mkDerivation {
          name = "amacrine";
          src = self;

          inherit (common.${system}) buildInputs;

          buildPhase = ''
            python3 ./colors.py > colors.json
          '';

          installPhase = ''
            mkdir -p $out
            cp colors.json $out/
          '';
        };

        colour-science = nixpkgs.legacyPackages.${system}.python3Packages.buildPythonPackage rec {
          pname = "colour-science";
          version = "0.4.7";

          build-system = [nixpkgs.legacyPackages.${system}.python3Packages.setuptools];
          pyproject = true;

          src = nixpkgs.legacyPackages.${system}.fetchFromGitHub {
            inherit pname version;
            owner = "colour-science";
            repo = "colour";
            rev = "a3bfe349685f528100672e5c8ca2dfeeef64a273";
            sha256 = "sha256-yu0mmXnCZD1gEuTeo31mRjl+CaMdnaDlltIHf2v57pU";
          };

          buildInputs = [
            (nixpkgs.legacyPackages.${system}.python3.withPackages (
              ps: with ps; [
                pip
                numpy
                typing-extensions
                scipy
                hatchling
              ]
            ))
          ];

          doCheck = false; # Set to true if the package has tests
        };

      });

      overlays.default = final: prev: { colors = self.packages.${final.system}.default; };

      devShells = eachSystem (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell { inherit (common.${system}) buildInputs; };
      });
    };
}
