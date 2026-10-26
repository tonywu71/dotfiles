#!/bin/bash
set -euo pipefail

source_dir=$(cd "$(dirname "$0")/.." && pwd)
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
mkdir -p "$temporary/home"
mkdir -p "$temporary/bin"
export SETTINGS_LOG="$temporary/settings.log"
export XDG_CONFIG_HOME="$temporary/config"
cat > "$temporary/bin/defaults" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$SETTINGS_LOG"
EOF
chmod +x "$temporary/bin/defaults"
export PATH="$temporary/bin:$PATH"
printf '[data]\n' > "$temporary/config.toml"
chezmoi_command=(chezmoi --config "$temporary/config.toml" --source "$source_dir"
    --destination "$temporary/home" --persistent-state "$temporary/state.boltdb"
    --cache "$temporary/cache" --no-tty)

for personal in false true; do
    rendered=$("${chezmoi_command[@]}" execute-template --init \
        --promptBool "Is this your personal Mac?=$personal" \
        --file "$source_dir/.chezmoi.toml.tmpl")
    grep -Fqx "personal = $personal" <<< "$rendered"
    grep -Fqx "sourceDir = \"$source_dir\"" <<< "$rendered"
done

# Missing data must protect the work shell just like an explicit false value.
for data in '{}' '{"personal":false}' '{"personal":true,"chezmoi":{"os":"linux"}}'; do
    ignored=$("${chezmoi_command[@]}" --override-data "$data" execute-template \
        --file "$source_dir/.chezmoiignore")
    grep -Fqx '.zshrc' <<< "$ignored"
    grep -Fqx '.zprofile' <<< "$ignored"
done

managed=$("${chezmoi_command[@]}" managed)
if grep -Eq '(^|/)(Brewfile|tests|scripts|vscode-extensions.txt)(/|$)' <<< "$managed"; then
    echo 'Support files must not be installed into the home directory.' >&2
    exit 1
fi
echo 'Personal-machine config and exclusions passed.'

for file in "$source_dir/dot_zprofile" "$source_dir/dot_zshrc"; do
    zsh -n "$file"
done
printf 'existing work zshrc\n' > "$temporary/home/.zshrc"
printf 'existing work zprofile\n' > "$temporary/home/.zprofile"
"${chezmoi_command[@]}" --override-data '{"personal":false}' apply
grep -Fqx 'existing work zshrc' "$temporary/home/.zshrc"
grep -Fqx 'existing work zprofile' "$temporary/home/.zprofile"
"${chezmoi_command[@]}" --override-data '{"personal":true,"chezmoi":{"os":"darwin"}}' \
    --force apply "$temporary/home/.zshrc" "$temporary/home/.zprofile"
cmp "$source_dir/dot_zshrc" "$temporary/home/.zshrc"
cmp "$source_dir/dot_zprofile" "$temporary/home/.zprofile"
echo 'Work shell preservation and personal shell installation passed.'

if [[ -e "$SETTINGS_LOG" || -e "$XDG_CONFIG_HOME/btop/btop.conf" ]]; then
    echo 'Work-mode apply must not run personal settings scripts.' >&2
    exit 1
fi

for file in "$source_dir"/run_onchange_after_*-settings.sh.tmpl; do
    for data in '{}' '{"personal":false}' '{"personal":true,"chezmoi":{"os":"linux"}}'; do
        rendered=$("${chezmoi_command[@]}" --override-data "$data" execute-template --file "$file")
        test -z "$rendered"
    done
    "${chezmoi_command[@]}" --override-data '{"personal":true,"chezmoi":{"os":"darwin"}}' \
        execute-template --file "$file" > "$temporary/$(basename "$file" .tmpl)"
    bash -n "$temporary/$(basename "$file" .tmpl)"
    shellcheck "$temporary/$(basename "$file" .tmpl)"
done

"${chezmoi_command[@]}" --override-data '{"personal":true,"chezmoi":{"os":"darwin"}}' --force apply
grep -Fqx 'color_theme = "dracula"' "$XDG_CONFIG_HOME/btop/btop.conf"
grep -Fqx 'write com.apple.finder ShowPathbar -bool true' "$SETTINGS_LOG"
grep -Fqx 'write com.apple.finder FXDefaultSearchScope -string SCcf' "$SETTINGS_LOG"
grep -Fqx 'write NSGlobalDomain InitialKeyRepeat -int 15' "$SETTINGS_LOG"
grep -Fqx 'write com.googlecode.iterm2 CopySelection -bool false' "$SETTINGS_LOG"
test "$(wc -l < "$SETTINGS_LOG" | tr -d ' ')" = 16

cp "$SETTINGS_LOG" "$temporary/first-apply.log"
"${chezmoi_command[@]}" --override-data '{"personal":true,"chezmoi":{"os":"darwin"}}' apply
cmp "$SETTINGS_LOG" "$temporary/first-apply.log"

printf 'color_theme = "Default"\nupdate_ms = 2000\ncolor_theme = "Other"\n' > "$XDG_CONFIG_HOME/btop/btop.conf"
app_script="$temporary/run_onchange_after_20-app-settings.sh"
bash "$app_script"
grep -Fqx 'update_ms = 2000' "$XDG_CONFIG_HOME/btop/btop.conf"
test "$(grep -c '^color_theme =' "$XDG_CONFIG_HOME/btop/btop.conf")" = 1
cp "$XDG_CONFIG_HOME/btop/btop.conf" "$temporary/first-btop.conf"
bash "$app_script"
cmp "$XDG_CONFIG_HOME/btop/btop.conf" "$temporary/first-btop.conf"

mv "$XDG_CONFIG_HOME/btop/btop.conf" "$temporary/symlink-target.conf"
ln -s "$temporary/symlink-target.conf" "$XDG_CONFIG_HOME/btop/btop.conf"
if bash "$app_script" 2>/dev/null; then
    echo 'The app settings script must preserve an existing btop symlink.' >&2
    exit 1
fi
cmp "$temporary/symlink-target.conf" "$temporary/first-btop.conf"
echo 'Settings isolation, repeat apply, and btop preservation passed.'

mkdir -p "$temporary/vscode-bin"
cat > "$temporary/vscode-bin/chezmoi" <<'EOF'
#!/bin/bash
printf '%s\n' "$TEST_PERSONAL"
EOF
cat > "$temporary/vscode-bin/code" <<'EOF'
#!/bin/bash
if [[ $1 == --list-extensions ]]; then
    echo adpyke.codesnap
else
    printf '%s\n' "$2" >> "$CODE_LOG"
fi
EOF
chmod +x "$temporary/vscode-bin/chezmoi" "$temporary/vscode-bin/code"
export CODE_LOG="$temporary/extensions.log"
extension_script="$source_dir/scripts/install-vscode-extensions.sh"
shellcheck "$extension_script"
if TEST_PERSONAL=false PATH="$temporary/vscode-bin:$PATH" bash "$extension_script" 2>/dev/null; then
    echo 'Extension installation must refuse work mode.' >&2
    exit 1
fi
test ! -e "$CODE_LOG"
TEST_PERSONAL=true PATH="$temporary/vscode-bin:$PATH" bash "$extension_script"
sed '/^adpyke.codesnap$/d; /^$/d' "$source_dir/vscode-extensions.txt" > "$temporary/expected-extensions.txt"
cmp "$CODE_LOG" "$temporary/expected-extensions.txt"
echo 'Extension installation skips installed IDs and refuses work mode.'
