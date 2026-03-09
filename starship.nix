colors: {
  format = "$username$hostname$localip$shlvl$directory$git_branch$git_commit$git_state$git_metrics$git_status$nix_shell$env_var$sudo$cmd_duration$line_break$jobs$time$status$netns$shell$character";

  character = {
    success_symbol = "[𝝺](bold ${colors.COLOR_CURSOR_BG})";
    error_symbol = "[𝝺](bold bright-red)";
  };

  directory = {
    truncation_length = 80;
  };

  palette = "ui";

  palettes.ui =
    let
      dim = colors.COLOR_UI_LEVEL_2_FG;
      bright = colors.COLOR_UI_LEVEL_3_FG;
    in
    {
      black = dim;
      red = dim;
      green = dim;
      blue = dim;
      yellow = dim;
      purple = dim;
      cyan = dim;
      white = dim;
      bright-black = bright;
      bright-red = bright;
      bright-green = bright;
      bright-blue = bright;
      bright-yellow = bright;
      bright-purple = bright;
      bright-cyan = bright;
      bright-white = bright;
    };
}
