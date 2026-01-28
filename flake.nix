{
  description = "Development shell of Chadwick Dahlquist";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-utils.url = "github:numtide/flake-utils";
    hx.url = "github:bugeats/hx";
    colors = {
      url = ./colors.json;
      flake = false;
    };
  };

  outputs =
    {
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        hx = inputs.hx.packages.${system}.default;
      in
      rec {
        packages = {
          # TODO
          default = pkgs.hello;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            packages.default
            hx
          ];
          shellHook = ''
            echo "λ bugeats mode engaged λ"
          '';
        };
      }
    );
}
