# dotfiles

- 💻 My personal dotfiles for my macOS setup.
- 🏡 Repository is managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Preliminaries

Install `brew`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

You will be prompted to install the Xcode command line tools. Accept, wait, and don't forget to add Homebrew to your `$PATH` by following the on-screen instructions.

Install `chezmoi`:

```bash
brew install chezmoi
```

## Install dotfiles

```bash
chezmoi init --apply https://github.com/tonywu71/dotfiles.git
```

## Install brew apps

```bash
chezmoi cd  # you should see a `Brewfile` in the directory
brew bundle
```

## Additional setup

`powerlevel10k`:

```bash
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

`amazon-q`:

```bash
q integrations install ssh
```

## Additional installs

Install `oh-my-zsh`:

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

**Manually** add the snippet below to your `.bashrc` or `.zshrc` to load the other shell dotfiles:

```bash
# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
```

> [!IMPORTANT]
> Do this manually as the bash configuration files often have pre-blocks for other programs like `oh-my-zsh` or `amazon-q`.

## Notes

- Machine-specific configurations should be stored in `~/.extra`. If exists, this file will be automatically sourced.
- More sensible data should be stored in `~/.env` and sourced only when necessary. If you want to store API keys, make sure to respect the *Principle of least privilege* when choosing the fine-grained permissions!
