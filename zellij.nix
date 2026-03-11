rgbcolors:

let
  rgb = color: "${toString color.r} ${toString color.g} ${toString color.b}";
in

''
  default_shell "fish"
  mouse_mode true
  pane_frames true
  scroll_buffer_size 200000
  default_layout "compact"
  theme "sh"

  themes {
    sh {
      fg ${rgb rgbcolors.COLOR_UI_LEVEL_3_FG}
      bg ${rgb rgbcolors.COLOR_UI_LEVEL_1_BG}
      black ${rgb rgbcolors.COLOR_NORMAL_BG}
      red ${rgb rgbcolors.COLOR_ANSI_RED}
      green ${rgb rgbcolors.COLOR_ANSI_GREEN}
      yellow ${rgb rgbcolors.COLOR_ANSI_YELLOW}
      blue ${rgb rgbcolors.COLOR_KEYWORD_FG}
      magenta ${rgb rgbcolors.COLOR_ANSI_MAGENTA}
      cyan ${rgb rgbcolors.COLOR_ANSI_CYAN}
      white ${rgb rgbcolors.COLOR_ANSI_WHITE}
      orange ${rgb rgbcolors.COLOR_STRING_FG_ALT}
    }
  }
''
