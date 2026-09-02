{
  pkgs,
  rgbcolors,
}:

let
  inherit (pkgs) lib;
  theme = import ./theme.nix rgbcolors;
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

pkgs.runCommand "zellij-config" { } ''
  mkdir -p $out
  cat ${./config.kdl} \
      ${pkgs.writeText "keybinds.kdl" keybinds} \
      ${pkgs.writeText "theme.kdl" theme} > $out/config.kdl
''
