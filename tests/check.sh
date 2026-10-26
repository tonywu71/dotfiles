#!/bin/bash
set -euo pipefail

source_dir=$(cd "$(dirname "$0")/.." && pwd)
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
mkdir -p "$temporary/home"
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
if grep -Eq '(^|/)(Brewfile|tests)(/|$)' <<< "$managed"; then
    echo 'Support files must not be installed into the home directory.' >&2
    exit 1
fi
echo 'Personal-machine config and exclusions passed.'
