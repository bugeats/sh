system: {
  gup = ''
    git fetch --all --prune
    git pull
  '';

  gca = ''
    if test (count $argv) -eq 0
        echo "Error: message required"
        return 1
    end
    git add -A
    git commit -m "$argv"
  '';

  gst = ''
    git status --short --branch
  '';

  wip = ''
    git add -A
    if test (count $argv) -eq 0
        git commit -m "WIP"
    else
        git commit -m "WIP ($argv)"
    end
  '';

  cls = ''
    if set -q ZELLIJ
        zellij action clear
    else if set -q TMUX
        tmux clear-history
    end

    clear
  '';

  nix-dev = ''
    if not nix eval .#devShells.${system} --quiet 2>/dev/null
        echo "nix dev shell flake not found"
        return 1
    end

    echo "found nix dev shell"
    echo ""
    nix develop --show-trace --trace-verbose --print-build-logs --command $SHELL
  '';

  path-short-display = ''
    set pathStr $argv[1]
    set head (dirname "$pathStr" | xargs basename)
    set tail (basename "$pathStr")
    echo "$head/$tail"
  '';

  set-no-wrap = ''
    setterm -linewrap off
  '';

  set-wrap = ''
    setterm -linewrap on
  '';

  niri-eq = ''
    niri msg action set-column-width 50%
    niri msg action focus-column-left
    niri msg action set-column-width 25%
    niri msg action focus-column-right
    niri msg action focus-column-right
    niri msg action set-column-width 25%
    niri msg action focus-column-left
    niri msg action center-column
  '';

  mastodon = ''
    ssh ssh://chadwick@mastodon.taho.it.com:8623 -t 'nix run github:bugeats/sh'
  '';

  saturn = ''
    ssh chadwick@saturn.local -t 'nix run github:bugeats/sh'
  '';

  bibi = ''
    ssh chadwick@bibi.local -t 'nix run github:bugeats/sh'
  '';

  claude = ''
    nix run github:bugeats/claude --refresh
  '';
}
