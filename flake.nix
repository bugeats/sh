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
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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

        stack = with pkgs; [
          nixfmt
          git
          fish
          tmux
          gitui
          terminaltexteffects
          zellij
        ];

        hx = inputs.hx.packages.${system}.default;
        configPath = inputs.configs;
      in
      rec {
        packages = {
          # TODO
          default = pkgs.alacritty;
        };

        homeConfigurations."chadwick" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };

        devShells.default = pkgs.mkShell {
          packages =
            with pkgs;
            [
              packages.default
            ]
            ++ stack;

          shellHook = ''
            # Set up config paths from Nix store
            export SHELL_CONFIG_ROOT="${configPath}"

            # Fish config
            export XDG_CONFIG_HOME="$SHELL_CONFIG_ROOT"

            # Tmux config
            export TMUX_CONF="$SHELL_CONFIG_ROOT/tmux/tmux.conf"
            alias tmux='tmux -f $TMUX_CONF'

            echo -e "\nbugeats\n    mode\n        engaged\n" | tte slide

            # Start fish shell if not already in fish
            if [ "$SHELL" != "$(which fish)" ]; then
              exec fish
            fi
          '';
        };
      }
    );
}

# if [ -z "$TMUX" ]; then
#   echo "Starting tmux session..."
#   exec tmux -f $TMUX_CONF new-session fish
# else
#   echo "Already in tmux session"
#   # Start fish shell if not already in fish
#   if [ "$SHELL" != "$(which fish)" ]; then
#     exec fish
#   fi
# fi
