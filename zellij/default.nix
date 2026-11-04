{
  pkgs,
  hexcolors,
  rgbcolors,
  zjstatus,
}:

let
  inherit (pkgs) lib;
  theme = import ./theme.nix rgbcolors;
  bar = import ./bar.nix { inherit hexcolors zjstatus; };
  bind = key: action: ''bind "Super Alt ${key}" { ${action}; }'';
  tabBind = n: bind (toString n) "GoToTab ${toString n}";

  sharedBinds = [
    (bind "h" ''MoveFocus "Left"'')
    (bind "j" ''MoveFocus "Down"'')
    (bind "k" ''MoveFocus "Up"'')
    (bind "l" ''MoveFocus "Right"'')
    (bind "y" ''Resize "Increase Left"'')
    (bind "u" ''Resize "Increase Down"'')
    (bind "i" ''Resize "Increase Up"'')
    (bind "o" ''Resize "Increase Right"'')
    (bind "s" ''NewPane "Right"'')
    (bind "v" ''NewPane "Down"'')
    (bind "t" "NewTab")
    (bind "x" "Quit")
    (bind "w" "CloseTab")
    (bind "q" "CloseFocus")
    (bind "g" ''SwitchToMode "Locked"'')
    (bind "c" "Clear")
    (bind "e" "EditScrollback")
    (bind "d" "Detach")
    (bind "f" ''SwitchToMode "EnterSearch"; SearchInput 0'')
    (bind "0" ''LaunchOrFocusPlugin "session-manager" { floating true; move_to_focused_tab true; }'')
    (bind "space" "ToggleFloatingPanes")
    (bind "enter" "ToggleFocusFullscreen")
  ]
  ++ map tabBind (lib.range 1 9);

  keybinds = ''
    keybinds clear-defaults=true {
        shared_except "locked" {
            ${lib.concatStringsSep "\n        " sharedBinds}
        }
        locked {
            ${bind "g" ''SwitchToMode "Normal"''}
        }
    }
  '';
in

# The session manager lists layouts from `layout_dir`, falling back to ~/.config/zellij/layouts
# rather than ZELLIJ_CONFIG_DIR, so the option must name this store path outright.
pkgs.runCommand "zellij-config" { } ''
  mkdir -p $out/layouts
  cat ${./config.kdl} \
      ${pkgs.writeText "keybinds.kdl" keybinds} \
      ${pkgs.writeText "theme.kdl" theme} > $out/config.kdl
  echo "layout_dir \"$out/layouts\"" >> $out/config.kdl
  cp ${pkgs.writeText "bar.kdl" bar} $out/layouts/bar.kdl
''
