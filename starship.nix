{ hexcolors, ... }:

{
  format = "$username$hostname$localip$shlvl$directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell$env_var$sudo$cmd_duration$line_break$jobs$time$status$netns$shell$character";

  character = {
    success_symbol = "[𝝺](bold ${hexcolors.COLOR_CURSOR_BG})";
    error_symbol = "[𝝺](bold bright-red)";
  };

  directory = {
    truncation_length = 80;
  };

  palette = "ui";

  palettes.ui =
    with hexcolors; {
      black = COLOR_ANSI_UI_BLACK;
      red = COLOR_ANSI_UI_RED;
      green = COLOR_ANSI_UI_GREEN;
      blue = COLOR_ANSI_UI_BLUE;
      yellow = COLOR_ANSI_UI_BLUE;
      purple = COLOR_ANSI_UI_MAGENTA;
      cyan = COLOR_ANSI_UI_CYAN;
      white = COLOR_ANSI_UI_WHITE;
      brigh-black = COLOR_ANSI_UI_BLACK_LIGHT;
      brigh-red = COLOR_ANSI_UI_RED_LIGHT;
      brigh-green = COLOR_ANSI_UI_GREEN_LIGHT;
      brigh-blue = COLOR_ANSI_UI_BLUE_LIGHT;
      brigh-yellow = COLOR_ANSI_UI_BLUE_LIGHT;
      brigh-purple = COLOR_ANSI_UI_MAGENTA_LIGHT;
      brigh-cyan = COLOR_ANSI_UI_CYAN_LIGHT;
      brigh-white = COLOR_ANSI_UI_WHITE_LIGHT;
    };
}
