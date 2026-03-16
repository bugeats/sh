{ pkgs, rgbcolors }:

let
  theme = import ./theme.nix rgbcolors;
in

pkgs.runCommand "zellij-config" { } ''
  mkdir -p $out
  cat ${./config.kdl} ${pkgs.writeText "theme.kdl" theme} > $out/config.kdl
''
