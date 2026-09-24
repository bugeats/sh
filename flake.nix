{
  description = "Portable shell environment of Chadwick Dahlquist";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    flake-utils.url = "github:numtide/flake-utils";
    colors.url = "github:bugeats/colors";
    hx.url = "github:bugeats/hx";
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
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
        pkgs = import inputs.nixpkgs { inherit system; };

        colors =
          (builtins.fromJSON (builtins.readFile "${inputs.colors.packages.${system}.json}/colors.json"))
          .colors;

        hexcolors = colors.hex;
        rgbcolors = colors.rgb;

        configInputs = {
          inherit hexcolors;
          identity = {
            name = "Chadwick Dahlquist";
            email = "chadwick@bugeats.net";
          };
        };

        hx = inputs.hx.packages.${system}.default;
        zjstatus = inputs.zjstatus.packages.${system}.default;

        toml = pkgs.formats.toml { };

        devStack = [
          hx
          pkgs.delta
          pkgs.fish
          pkgs.gh
          pkgs.gh-dash
          pkgs.git
          pkgs.git-lfs
          pkgs.gitui
          pkgs.jujutsu
          pkgs.mergiraf
          pkgs.starship
          pkgs.tmux
          pkgs.zellij
        ];
      in
      rec {
        packages.fish-config = import ./fish { inherit pkgs hexcolors system; };

        packages.starship-config = toml.generate "starship.toml" (import ./starship.nix configInputs);

        packages.git-config = pkgs.writeText "gitconfig" (import ./git.nix configInputs);

        packages.jj-config = toml.generate "jj.toml" (import ./jj.nix configInputs);

        packages.gitui-config = pkgs.runCommand "gitui-config" { } ''
          mkdir -p $out
          cp ${pkgs.writeText "theme.ron" (import ./gitui.nix configInputs)} $out/theme.ron
        '';

        packages.zellij-config = import ./zellij {
          inherit
            pkgs
            hexcolors
            rgbcolors
            zjstatus
            ;
        };

        packages.zj = pkgs.writeShellApplication {
          name = "zj";
          runtimeInputs = [ pkgs.zellij ];
          runtimeEnv.ZELLIJ_CONFIG_DIR = "${packages.zellij-config}";
          text = ''
            exec zellij attach --create "$(basename "$PWD")" "$@"
          '';
        };

        packages.default = pkgs.writeShellApplication {
          name = "sh-bootstrap";
          runtimeInputs = devStack ++ [
            packages.zj
          ];
          runtimeEnv = {
            SHELL = "${pkgs.fish}/bin/fish";
            EDITOR = "${hx}/bin/hx";
            VISUAL = "${hx}/bin/hx";
            FISH_CONFIG = "${packages.fish-config}";
            STARSHIP_CONFIG = "${packages.starship-config}";
            GIT_CONFIG_GLOBAL = "${packages.git-config}";
            GITUI_CONFIG = "${packages.gitui-config}";
            JJ_CONFIG = "${packages.jj-config}";
            ZELLIJ_CONFIG_DIR = "${packages.zellij-config}";
            # Trailing colon keeps the compiled-in terminfo defaults
            TERMINFO_DIRS = "${pkgs.alacritty.terminfo}/share/terminfo:";
          };
          text = builtins.readFile ./bootstrap.sh;
        };
      }
    );
}
