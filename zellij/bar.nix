{
  hexcolors,
  zjstatus,
}:

''
  layout {
    default_tab_template {
      pane size=1 borderless=true {
        plugin location="file:${zjstatus}/bin/zjstatus.wasm" {
          color_alt "${hexcolors.COLOR_ANSI_MAGENTA}"
          color_bg1 "${hexcolors.COLOR_UI_LEVEL_1_BG}"
          color_bg2 "${hexcolors.COLOR_UI_LEVEL_2_BG}"
          color_fg1 "${hexcolors.COLOR_UI_LEVEL_1_FG}"
          color_fg3 "${hexcolors.COLOR_UI_LEVEL_3_FG}"

          format_left  "{command_host}{tabs}"
          format_space "#[bg=$bg1]"

          command_host_command  "hostname -s"
          command_host_format   "#[fg=$alt,bg=$bg2]⅀ {stdout} #[fg=$bg2,bg=$bg1]🭬"
          command_host_interval "0"

          tab_active "#[fg=$fg3,bg=$bg1,bold]♯{index} {name} "
          tab_normal "#[fg=$fg1,bg=$bg1]♯{index} {name} "
        }
      }
      children
    }
  }
''
