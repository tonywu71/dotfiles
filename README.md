# dotfiles

- 💻 My personal dotfiles for my macOS setup.
- 🏡 Repository is managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

## Preliminaries

First, install `brew`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Then:

- Accept the Xcode command line tools installation prompt
- Wait for the installation to complete
- Add Homebrew to your `$PATH` by following the on-screen instructions. An example command is shown below.

```bash
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

Finally, install `chezmoi`:

```bash
brew install chezmoi
```

## Install dotfiles

Now that you have `git` and `chezmoi` installed, clone this repository where you want to edit it, and tell `chezmoi` to use that folder as its source:

```bash
git clone https://github.com/tonywu71/dotfiles.git ~/code/personal/dotfiles
chezmoi init --source ~/code/personal/dotfiles
chezmoi diff
chezmoi apply
```

This way `chezmoi diff` and `chezmoi apply` read your edits directly. You do not need to push before applying.

### Personal and work Macs

`chezmoi init` asks whether this is your personal Mac. Answer no on a work Mac.
The answer is saved in `~/.config/chezmoi/chezmoi.toml`, outside this repo:

```toml
[data]
personal = false
```

`personal` is our custom variable in chezmoi's built-in config file. It defaults
to false. Personal shell files and setup scripts require `personal = true` and
macOS. Work Macs keep their existing `.zshrc` and `.zprofile`. The existing shared
`.aliases` and `.gitconfig` are still managed on both kinds of Mac.

For an existing checkout, run `chezmoi init` to generate the local config, then
review `chezmoi diff` before applying anything. Changing the local value later
does not undo settings that were already applied.

## Install brew formulae and casks

Sign in to the Mac App Store first (open the App Store app and log in with your Apple ID). `brew bundle` uses `mas` to install the App Store apps listed in the `Brewfile`, and it fails if you are signed out.

```bash
chezmoi cd  # you should see a `Brewfile` in the directory
brew bundle
```

## Install oh-my-zsh

> [!WARNING]
> This section and the zshrc sections below are for my personal laptop only. Do not run them on my work laptop, which has its own `.zshrc`.

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Additional zshrc-related setup

> [!TIP]
> For cleaner files, separate the different apps with `---` lines, as shown below.

### Set up oh-my-zsh

Override the default settings in `~/.zshrc` with the following snippet to:

- Remove the unused settings from `~/.zshrc` for clarity
- Enable automatic updates
- Install `oh-my-zsh` plugins

```bash
# ------------------- oh-my-zsh -------------------
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
plugins=(git)
```

### Set up other bash plugins

```bash
# ------------------- fzf -------------------
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)


# ------------------- powerlevel10k -------------------
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme


# ------------------- zsh-syntax-highlighting -------------------
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# ----------------------------------------------
```

### Link to other shell dotfiles

*Manually* add the snippet below to your `.zshrc`. `.zprofile`, and `.bashrc` files to load the dotfiles automatically at shell startup.

```bash
# ------------------- load dotfiles -------------------
# Load the following shell dotfiles:
# * ~/.path can be used to extend `$PATH`.
# * ~/.exports can be used for non-confidential environment variables.
# * ~/.aliases can be used for creating custom aliases.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,exports,aliases,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
```

> [!IMPORTANT]
> Do this *manually* as the bash configuration files often have pre-blocks for other programs like `oh-my-zsh`, `powerlevel10k`, and `amazon-q`.

## App-specific setup

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

And add the new key to the Apple Keychain (if applicable):

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Following this [tutorial](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account), add the newly created SSH key here: <https://github.com/settings/keys>.

## Notes

- Machine-specific configurations should be stored in `~/.extra`. If exists, this file will be automatically sourced.
- More sensible data should be stored in `~/.env` and sourced only when necessary. If you want to store API keys, make sure to respect the *Principle of least privilege* when choosing the fine-grained permissions!
- (Optional) Install Rosetta:

    ```bash
    softwareupdate --install-rosetta
    ```

## Checks

Run `bash tests/check.sh` to check the templates and personal-machine exclusions.
The checks use a temporary destination and do not apply settings to your Mac.
