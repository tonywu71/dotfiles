#!/bin/bash
set -euo pipefail

if [[ $(uname -s) != Darwin ]] || [[ $(chezmoi execute-template '{{ index . "personal" | default false }}') != true ]]; then
    echo 'Run this only on a personal Mac with personal = true in the chezmoi config.' >&2
    exit 1
fi

source_dir=$(cd "$(dirname "$0")/.." && pwd)
code_command=code
if ! command -v code >/dev/null; then
    code_command='/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code'
fi
installed=$("$code_command" --list-extensions)
while IFS= read -r extension; do
    [[ -n "$extension" ]] || continue
    if ! grep -Fxiq "$extension" <<< "$installed"; then
        "$code_command" --install-extension "$extension"
    fi
done < "$source_dir/vscode-extensions.txt"
