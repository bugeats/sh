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
            pkgs.fish
            pkgs.tmux
            pkgs.gitui
          ];
          shellHook = ''
            # Set up config paths
            export SHELL_CONFIG_ROOT="$(pwd)/config"

            # Fish config
            export XDG_CONFIG_HOME="$SHELL_CONFIG_ROOT"

            # Tmux config
            export TMUX_CONF="$SHELL_CONFIG_ROOT/tmux/tmux.conf"
            alias tmux='tmux -f $TMUX_CONF'

            echo "λ bugeats mode engaged λ"
            echo ""
            echo "Available tools:"
            echo "  - hx     : Helix editor"
            echo "  - fish   : Friendly interactive shell"
            echo "  - tmux   : Terminal multiplexer"
            echo "  - gitui  : Fast terminal UI for git"
            echo ""

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
