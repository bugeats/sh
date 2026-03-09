fish_config="$HOME/.config/fish"
starship_config="$HOME/.config/starship.toml"
git_config="$HOME/.gitconfig"
gitui_config="$HOME/.config/gitui"

link_config() {
  if [ -f "$2" ] && [ ! -L "$2" ]; then
    mv "$2" "$2.backup"
  fi
  ln -sf "$1" "$2"
}

# shellcheck disable=SC2329
restore_backup() {
  if [ -f "$1.backup" ]; then
    mv "$1.backup" "$1"
  fi
}

install_config() {
  mkdir -p "$fish_config/functions"

  link_config "$SH_CONFIG/fish/config.fish" "$fish_config/config.fish"

  for fn in "$SH_CONFIG/fish/functions/"*.fish; do
    ln -sf "$fn" "$fish_config/functions/$(basename "$fn")"
  done

  link_config "$SH_CONFIG/starship.toml" "$starship_config"
  link_config "$SH_CONFIG/gitconfig" "$git_config"

  mkdir -p "$gitui_config"
  link_config "$SH_CONFIG/gitui/theme.ron" "$gitui_config/theme.ron"
}

remove_managed_symlinks() {
  for f in "$fish_config/config.fish" "$starship_config" "$git_config" "$gitui_config/theme.ron" "$fish_config/functions/"*.fish; do
    if [ -L "$f" ] && [[ "$(readlink "$f")" == /nix/store/* ]]; then
      rm "$f"
    fi
  done
}

# shellcheck disable=SC2329
on_exit() {
  remove_managed_symlinks
  restore_backup "$fish_config/config.fish"
  restore_backup "$starship_config"
  restore_backup "$git_config"
  restore_backup "$gitui_config/theme.ron"
}

trap on_exit EXIT
remove_managed_symlinks
install_config

fish "$@" && exit_code=$? || exit_code=$?
exit "$exit_code"
