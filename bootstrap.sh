echo "bugeats/sh"

fish_config="$HOME/.config/fish"
gitui_config="$HOME/.config/gitui"

backup() {
  if [ -f "$1" ] && [ ! -L "$1" ]; then
    mv "$1" "$1.bugeats-was-here"
  fi
}

mkdir -p "$fish_config/functions"

backup "$fish_config/config.fish"
ln -sf "$FISH_CONFIG/config.fish" "$fish_config/config.fish"

for fn in "$FISH_CONFIG/functions/"*.fish; do
  ln -sf "$fn" "$fish_config/functions/$(basename "$fn")"
done

mkdir -p "$gitui_config"
backup "$gitui_config/theme.ron"
ln -sf "$GITUI_CONFIG/theme.ron" "$gitui_config/theme.ron"

exec fish "$@"
