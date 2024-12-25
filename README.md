# dotfiles

- 💻 My personal dotfiles for my macOS setup.
- 🏡 Repository is managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Quick start

```bash
chezmoi init --apply https://github.com/tonywu71/dotfiles.git
```

Then add the following to your `.bashrc` or `.zshrc` to load the other shell dotfiles:

```bash
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
```

## Notes

- Machine-specific configurations should be stored in `~/.extra`. If exists, this file will be automatically sourced.
- More sensible data should be stored in `~/.env` and sourced only when necessary. If you want to store API keys, make sure to respect the *Principle of least privilege* when choosing the fine-grained permissions!
