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
    configs = {
      url = ./config;
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
        configPath = inputs.configs;
      in
      rec {
        packages = {
          # TODO
          default = pkgs.hello;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            packages.default
            git
            fish
            tmux
            gitui
            terminaltexteffects
          ];
          shellHook = ''
            # Set up config paths from Nix store
            export SHELL_CONFIG_ROOT="${configPath}"

            # Fish config
            export XDG_CONFIG_HOME="$SHELL_CONFIG_ROOT"

            # Tmux config
            export TMUX_CONF="$SHELL_CONFIG_ROOT/tmux/tmux.conf"
            alias tmux='tmux -f $TMUX_CONF'

            echo -e "bugeats\n    mode\n        engaged" | tte slide

            # Start tmux if not already in a tmux session
            if [ -z "$TMUX" ]; then
              echo "Starting tmux session..."
              exec tmux -f $TMUX_CONF new-session fish
            else
              echo "Already in tmux session"
              # Start fish shell if not already in fish
              if [ "$SHELL" != "$(which fish)" ]; then
                exec fish
              fi
            fi
          '';
        };
      }
    );
}
