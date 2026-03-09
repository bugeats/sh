hexcolors:

''
  [alias]
      l = log --pretty=format:\"%C(green)%h %C(reset)%C(${hexcolors.COLOR_UI_LEVEL_2_FG})%as %C(white dim)%an%C(magenta)%d%n                   %f%n\"
      b = branch --sort=-committerdate

  [branch]
      autosetupmerge = always
      autosetuprebase = always

  [color]
      ui = true

  [color "diff"]
      meta = 11
      frag = magenta bold
      func = 146 bold
      commit = yellow bold
      old = red bold
      new = green bold
      whitespace = red reverse

  [color "diff-highlight"]
      oldNormal = red bold
      oldHighlight = red bold 52
      newNormal = green bold
      newHighlight = green bold 22

  [core]
      pager = delta

  [delta]
      navigate = true
      side-by-side = true
      line-numbers = true
      dark = true
      true-color = auto

  [fetch]
      prune = true

  [filter "lfs"]
      clean = git-lfs clean -- %f
      smudge = git-lfs smudge -- %f
      process = git-lfs filter-process
      required = true

  [init]
      defaultBranch = main

  [interactive]
      diffFilter = delta --color-only

  [merge]
      conflictStyle = zdiff3
      ff = only

  [pull]
      rebase = true

  [push]
      autoSetupRemote = true

  [rerere]
      enabled = true

  [user]
      name = Chadwick Dahlquist
      email = chadwick@bugeats.net
''
