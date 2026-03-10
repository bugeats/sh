{
  description = "Portable shell environment of Chadwick Dahlquist";

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

        fishConfigDir = import ./fish { inherit pkgs hexcolors system; };
        starshipSettings = import ./starship.nix hexcolors;
        gitconfigContent = import ./git.nix hexcolors;
        gituiTheme = import ./gitui.nix hexcolors;

        hx = inputs.hx.packages.${system}.default;

        config-dir = pkgs.runCommand "sh-config" { nativeBuildInputs = [ pkgs.yj ]; } ''
          mkdir -p $out

          cp -r ${fishConfigDir} $out/fish

          echo '${builtins.toJSON starshipSettings}' | yj -jt > $out/starship.toml

          cp ${pkgs.writeText "gitconfig" gitconfigContent} $out/gitconfig

          mkdir -p $out/gitui
          cp ${pkgs.writeText "theme.ron" gituiTheme} $out/gitui/theme.ron
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
            pkgs.git-lfs
            pkgs.delta
            pkgs.gh
            pkgs.gh-dash
            pkgs.mergiraf
            pkgs.gitui
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
