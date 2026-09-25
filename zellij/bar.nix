{
  hexcolors,
  zjstatus,
}:

let
  edge = from: to: fg: ''#[fg=${from},bg=${to}]█ #[fg=${fg},bg=${to}]'';
in

''
  layout {
    default_tab_template {
      pane size=1 borderless=true {
        plugin location="file:${zjstatus}/bin/zjstatus.wasm" {
          color_alt "${hexcolors.COLOR_ANSI_MAGENTA}"
          color_bg1 "${hexcolors.COLOR_UI_LEVEL_1_BG}"
          color_bg2 "${hexcolors.COLOR_UI_LEVEL_2_BG}"
          color_bg3 "${hexcolors.COLOR_UI_LEVEL_3_BG}"
          color_fg1 "${hexcolors.COLOR_UI_LEVEL_1_FG}"
          color_fg2 "${hexcolors.COLOR_UI_LEVEL_2_FG}"
          color_fg3 "${hexcolors.COLOR_UI_LEVEL_3_FG}"

          command_host_command  "hostname -s"
          command_host_format   "{stdout}"
          command_host_interval "0"

          format_left  "#[fg=$alt,bg=$bg1]{mode} #[fg=$bg3,bg=$bg2]▐#[fg=$fg3,bg=$bg3]{command_host}${edge "$bg3" "$bg2" "$fg2"}{session}${edge "$bg2" "$bg1" "$fg1"}{tabs}"
          format_space "#[bg=$bg1]"

          tab_active    "#[fg=$fg1,bg=$bg1]▌#[fg=$fg2,bg=$bg1]{index}#[fg=$fg1,bg=$bg1]▐ {name} "
          tab_normal    "#[fg=$fg1,bg=$bg1]▏{index}▕ {name} "

          // Modes beyond normal and locked are reached only by accident; naming
          // them makes the way out obvious.
          mode_normal          "ℤ"
          mode_locked          "⛧ "
          mode_tmux            "{name}"
          mode_default_to_mode "tmux"
        }
      }
      children
    }
  }
''
