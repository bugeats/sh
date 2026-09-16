{ hexcolors, identity }:

let
  # jj's defaults restyle every label on the working-copy row, so each override
  # needs a "working_copy <label>" twin or the default bright variant wins there.
  withWorkingCopy =
    colors:
    colors
    // builtins.listToAttrs (
      map (name: {
        name = "working_copy ${name}";
        value = colors.${name};
      }) (builtins.attrNames colors)
    );
in
{
  user = identity;

  ui = {
    diff-formatter = ":git";
    pager = "delta";
  };

  colors = withWorkingCopy {
    commit_id = hexcolors.COLOR_UI_LEVEL_1_FG;
    author = hexcolors.COLOR_UI_LEVEL_3_FG;
    committer = hexcolors.COLOR_UI_LEVEL_3_FG;
    timestamp = hexcolors.COLOR_UI_LEVEL_2_FG;
    bookmark = hexcolors.COLOR_KEYWORD_FG;
    bookmarks = hexcolors.COLOR_KEYWORD_FG;
    local_bookmarks = hexcolors.COLOR_KEYWORD_FG;
    remote_bookmarks = hexcolors.COLOR_KEYWORD_FG;
    tag = hexcolors.COLOR_KEYWORD_FG_ALT;
    tags = hexcolors.COLOR_KEYWORD_FG_ALT;
  };
}
