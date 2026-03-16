{
  description = "Portable shell environment of Chadwick Dahlquist";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-utils.url = "github:numtide/flake-utils";
    colors.url = "github:bugeats/colors";
    hx.url = "github:bugeats/hx";
    zellij-nix.url = "github:a-kenji/zellij-nix";
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

        colors =
          (builtins.fromJSON (builtins.readFile "${inputs.colors.packages.${system}.json}/colors.json"))
          .colors;

        hexcolors = colors.hex;
        rgbcolors = colors.rgb;

        hx = inputs.hx.packages.${system}.default;
        zellij = inputs.zellij-nix.packages.${system}.default;
      in
      rec {
        packages.fish-config = import ./fish { inherit pkgs hexcolors system; };

        packages.starship-config = pkgs.runCommand "starship-config" { nativeBuildInputs = [ pkgs.yj ]; } ''
          echo '${builtins.toJSON (import ./starship.nix hexcolors)}' | yj -jt > $out
        '';

        packages.git-config = pkgs.writeText "gitconfig" (import ./git.nix hexcolors);

        packages.gitui-config = pkgs.runCommand "gitui-config" { } ''
          mkdir -p $out
          cp ${pkgs.writeText "theme.ron" (import ./gitui.nix hexcolors)} $out/theme.ron
        '';

        packages.zellij-config = import ./zellij { inherit pkgs rgbcolors; };

        packages.default = pkgs.writeShellApplication {
          name = "sh-bootstrap";
          runtimeInputs = [
            pkgs.fish
            pkgs.starship
            pkgs.tmux
            pkgs.git
            pkgs.git-lfs
            pkgs.delta
            pkgs.gh
            pkgs.gh-dash
            pkgs.mergiraf
            pkgs.gitui
            hx
            zellij
          ];
          runtimeEnv = {
            SHELL = "${pkgs.fish}/bin/fish";
            EDITOR = "${hx}/bin/hx";
            VISUAL = "${hx}/bin/hx";
            FISH_CONFIG = "${packages.fish-config}";
            STARSHIP_CONFIG = "${packages.starship-config}";
            GIT_CONFIG_GLOBAL = "${packages.git-config}";
            GITUI_CONFIG = "${packages.gitui-config}";
            ZELLIJ_CONFIG_DIR = "${packages.zellij-config}";
          };
          text = builtins.readFile ./bootstrap.sh;
        };
      }
    );
}
