rgbcolors:

let
  rgb = color: "${toString color.r} ${toString color.g} ${toString color.b}";
in

''
  themes {
    melanin {
      text_unselected {
        base ${rgb rgbcolors.COLOR_NORMAL_FG}
        background ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_ANSI_GREEN}
        emphasis_1 ${rgb rgbcolors.COLOR_ANSI_CYAN}
        emphasis_2 ${rgb rgbcolors.COLOR_ANSI_BLUE}
        emphasis_3 ${rgb rgbcolors.COLOR_ANSI_MAGENTA}
      }
      text_selected {
        base ${rgb rgbcolors.COLOR_NORMAL_FG}
        background ${rgb rgbcolors.COLOR_SELECTION_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_ANSI_GREEN}
        emphasis_1 ${rgb rgbcolors.COLOR_ANSI_CYAN}
        emphasis_2 ${rgb rgbcolors.COLOR_ANSI_BLUE}
        emphasis_3 ${rgb rgbcolors.COLOR_ANSI_MAGENTA}
      }
      ribbon_selected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
      }
      ribbon_unselected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
      }
      table_title {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_2_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
      }
      table_cell_selected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_3_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
      }
      table_cell_unselected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_2_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
      }
      list_selected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_3_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
      }
      list_unselected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        background ${rgb rgbcolors.COLOR_UI_LEVEL_2_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
      }
      frame_selected {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        background ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_1_FG}
      }
      frame_unselected {
        base ${rgb rgbcolors.COLOR_NORMAL_BG}
        background ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_1 ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_2 ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_3 ${rgb rgbcolors.COLOR_NORMAL_BG}
      }
      frame_highlight {
        base ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        background ${rgb rgbcolors.COLOR_NORMAL_BG}
        emphasis_0 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_1 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_2 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
        emphasis_3 ${rgb rgbcolors.COLOR_UI_LEVEL_2_FG}
      }
      exit_code_success {
        base ${rgb rgbcolors.COLOR_ANSI_GREEN}
        background 0
        emphasis_0 ${rgb rgbcolors.COLOR_ANSI_CYAN}
        emphasis_1 ${rgb rgbcolors.COLOR_ANSI_BLUE}
        emphasis_2 ${rgb rgbcolors.COLOR_ANSI_MAGENTA}
        emphasis_3 ${rgb rgbcolors.COLOR_ANSI_CYAN}
      }
      exit_code_error {
        base ${rgb rgbcolors.COLOR_ANSI_RED}
        background 0
        emphasis_0 ${rgb rgbcolors.COLOR_ANSI_YELLOW}
        emphasis_1 ${rgb rgbcolors.COLOR_ANSI_RED}
        emphasis_2 ${rgb rgbcolors.COLOR_ANSI_MAGENTA}
        emphasis_3 ${rgb rgbcolors.COLOR_ANSI_YELLOW}
      }
      multiplayer_user_colors {
        player_1 177 98 134
        player_2 69 133 136
        player_3 0
        player_4 215 153 33
        player_5 104 157 106
        player_6 0
        player_7 204 36 29
        player_8 0
        player_9 0
        player_10 0
      }
    }
  }
''
