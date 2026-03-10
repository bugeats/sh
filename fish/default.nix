{
  pkgs,
  hexcolors,
  system,
}:

let
  stripHash = color: builtins.substring 1 (-1) color;

  functions = import ./functions.nix system;

  functionFiles = builtins.mapAttrs (
    name: body:
    pkgs.writeText "${name}.fish" ''
      function ${name}
      ${body}end
    ''
  ) functions;

  configFile = pkgs.writeText "config.fish" ''
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
in
pkgs.runCommand "fish-config" { } ''
  mkdir -p $out/functions

  cp ${configFile} $out/config.fish

  ${builtins.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: file: "cp ${file} $out/functions/${name}.fish") functionFiles
  )}
''
