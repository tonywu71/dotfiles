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

Now that you have `git` and `chezmoi` installed, you can download this repository with:

```bash
chezmoi init --apply https://github.com/tonywu71/dotfiles.git
```

## Install brew apps

```bash
chezmoi cd  # you should see a `Brewfile` in the directory
brew bundle
```

## Additional `zshrc`-related setup

> [!TIP]
> For cleaner files, separate the different apps with `---` lines, e.g.:
>
> ```bash
> # ------------------- oh-my-zsh -------------------
> #
> # ...
> # 
> # 
> # ------------------- zsh-syntax-highlighting -------------------
> # 
> # ...
> # 
> # 
> # ----------------------------------------------
> ```

`fzf`:

```bash
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
```

`oh-my-zsh`:

Remove the unused settings from `~/.zshrc` (you can keep just the theme and auto-update blocks) and enable automatic updates.

`powerlevel10k`:

```bash
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
```

`zsh-syntax-highlighting`:

```bash
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

## Other setup

`amazon-q`:

```bash
q integrations install ssh
```

`brew`:

Setup Brew to upgrade all formulae and casks and run its `cleanup` command once a week.

```bash
brew autoupdate start 604800 --cleanup --upgrade
```

`github`:

Login with `gh`:

```bash
gh auth login
```

Add an SSH key for GitHub to the `ssh-agent` using this [guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

```bash
ssh-keygen -t ed25519 -C "28306721+tonywu71@users.noreply.github.com"
eval "$(ssh-agent -s)"
touch ~/.ssh/config
open ~/.ssh/config
```

Then append these lines:

```ssh-config
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
```

## Additional installs

Install `oh-my-zsh`:

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

From the Mac App Store, download the following apps using `mas`:

```bash
mas install 937984704  # Amphetamine
mas install 1039633667  # Irvue
mas install 1289583905  # Pixelmator Pro
mas install 1444636541  # Photomator
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
- (Optional) Install Rosetta

    ```bash
    softwareupdate --install-rosetta
    ```
