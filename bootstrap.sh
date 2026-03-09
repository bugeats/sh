fish_config="$HOME/.config/fish"
starship_config="$HOME/.config/starship.toml"

install_config() {
  mkdir -p "$fish_config/functions"

  # config.fish
  if [ -f "$fish_config/config.fish" ] && [ ! -L "$fish_config/config.fish" ]; then
    mv "$fish_config/config.fish" "$fish_config/config.fish.backup"
  fi
  ln -sf "$SH_CONFIG/fish/config.fish" "$fish_config/config.fish"

  # fish functions
  for fn in "$SH_CONFIG/fish/functions/"*.fish; do
    ln -sf "$fn" "$fish_config/functions/$(basename "$fn")"
  done

  # starship.toml
  if [ -f "$starship_config" ] && [ ! -L "$starship_config" ]; then
    mv "$starship_config" "$starship_config.backup"
  fi
  ln -sf "$SH_CONFIG/starship.toml" "$starship_config"
}

remove_managed_symlinks() {
  for f in "$fish_config/config.fish" "$starship_config" "$fish_config/functions/"*.fish; do
    if [ -L "$f" ] && [[ "$(readlink "$f")" == /nix/store/* ]]; then
      rm "$f"
    fi
  done
}

# shellcheck disable=SC2329
restore_backups() {
  if [ -f "$fish_config/config.fish.backup" ]; then
    mv "$fish_config/config.fish.backup" "$fish_config/config.fish"
  fi

  if [ -f "$starship_config.backup" ]; then
    mv "$starship_config.backup" "$starship_config"
  fi
}

# shellcheck disable=SC2329
on_exit() {
  remove_managed_symlinks
  restore_backups
}

trap on_exit EXIT
remove_managed_symlinks
install_config

fish "$@" && exit_code=$? || exit_code=$?
exit "$exit_code"
