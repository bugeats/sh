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

  colors = with hexcolors; {
      fish_color_normal = COLOR_NORMAL_FG; # default color
      fish_color_command = COLOR_KEYWORD_FG; # commands like echo
      fish_color_builtin = COLOR_KEYWORD_FG_ALT; # builtin commands like cd and set - this falls back on the command color if unset
      fish_color_function = COLOR_KEYWORD_FG; # user-defined functions - this falls back on the command color if unset
      fish_color_keyword = COLOR_KEYWORD_FG; # keywords like if - this falls back on the command color if unset
      fish_color_quote = COLOR_STRING_FG; # quoted text like "abc"
      fish_color_redirection = COLOR_NORMAL_FG_ALT; # IO redirections like >/dev/null
      fish_color_end = COLOR_PUNCTUATION_FG; # process separators like ; and &
      fish_color_error = COLOR_ERROR_FG; # syntax errors
      fish_color_param = COLOR_KEYWORD_FG_ALT; # ordinary command parameters
      fish_color_valid_path = COLOR_STRING_FG_ALT; # parameters and redirection targets that are filenames (if the file exists)
      fish_color_option = COLOR_UI_LEVEL_3_FG; # options starting with “-”, up to the first “--” parameter
      fish_color_comment = COLOR_COMMENT_FG; # comments like ‘# important’
      fish_color_selection = COLOR_CURSOR_BG; # selected text in vi visual mode
      fish_color_operator = COLOR_PUNCTUATION_FG; # parameter expansion operators like * and ~
      fish_color_escape = COLOR_STRING_FG_ALT; # character escapes like \n and \x70
      fish_color_autosuggestion = COLOR_COMMENT_FG; # autosuggestions (the proposed rest of a command)
      fish_color_cwd = COLOR_STRING_FG_ALT; # the current working directory in the default prompt
      fish_color_cwd_root = FG_WARN; # the current working directory in the default prompt for the root user
      fish_color_user = COLOR_NORMAL_FG; # the username in the default prompt
      fish_color_host = COLOR_NORMAL_FG_ALT; # the hostname in the default prompt
      fish_color_host_remote = COLOR_KEYWORD_FG_ALT; # the hostname in the default prompt for remote sessions (like ssh)
      fish_color_status = FG_WARN; # the last command’s nonzero exit code in the default prompt
      fish_color_cancel = FG_INFO; # the ‘^C’ indicator on a canceled command
      fish_color_search_match = COLOR_COMMENT_FG; # history search matches and selected pager items (background only)
      fish_color_history_current = COLOR_UI_LEVEL_3_FG; # the current position in the history for commands like dirh and cdh
  };

  colors_k_v = builtins.mapAttrs (k: v: "set --universal ${k} ${stripHash v}") colors;
  colors_lines = pkgs.lib.strings.concatStringsSep "\n" (builtins.attrValues colors_k_v);

  configFile = pkgs.writeText "config.fish" ''
    ${colors_lines}

    if test -n "$IN_NIX_SHELL"
        printf "nix shell:\n"
        if test -n "$buildInputs"
            echo $buildInputs | tr ' ' '\n'
        end
    else
        nix-dev
    end

    COMPLETE=fish jj | source
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

