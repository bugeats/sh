{
  description = "Fish shell environment of Chadwick Dahlquist";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-utils.url = "github:numtide/flake-utils";
    colors.url = "github:bugeats/colors";
    hx.url = "github:bugeats/hx";
  };

  outputs =
    {
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };

        hexcolors =
          (builtins.fromJSON (builtins.readFile "${inputs.colors.packages.${system}.json}/colors.json"))
          .colors.hex;

        stripHash = color: builtins.substring 1 (-1) color;

        functions = import ./functions.nix system;
        starshipSettings = import ./starship.nix hexcolors;

        hx = inputs.hx.packages.${system}.default;

        functionFiles = builtins.mapAttrs (
          name: body:
          pkgs.writeText "${name}.fish" ''
            function ${name}
            ${body}end
          ''
        ) functions;

        configFish = pkgs.writeText "config.fish" ''
          set --universal fish_color_search_match ${stripHash hexcolors.COLOR_COMMENT_FG}
          set --universal fish_color_autosuggestion ${stripHash hexcolors.COLOR_COMMENT_FG}

          if test -n "$IN_NIX_SHELL"
              printf "nix shell:\n"
              if test -n "$buildInputs"
                  echo $buildInputs | tr ' ' '\n'
              end
          else
              nix-dev
          end

          starship init fish | source
        '';

        config-dir = pkgs.runCommand "sh-config" { nativeBuildInputs = [ pkgs.yj ]; } ''
          mkdir -p $out/fish/functions

          cp ${configFish} $out/fish/config.fish

          ${builtins.concatStringsSep "\n" (
            pkgs.lib.mapAttrsToList (name: file: "cp ${file} $out/fish/functions/${name}.fish") functionFiles
          )}

          echo '${builtins.toJSON starshipSettings}' | yj -jt > $out/starship.toml
        '';
      in
      {
        packages.default = pkgs.writeShellApplication {
          name = "sh-bootstrap";
          runtimeInputs = [
            pkgs.fish
            pkgs.starship
            pkgs.tmux
            pkgs.git
            hx
          ];
          runtimeEnv = {
            SH_CONFIG = "${config-dir}";
          };
          text = builtins.readFile ./bootstrap.sh;
        };
      }
    );
}
