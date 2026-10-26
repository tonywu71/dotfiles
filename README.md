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
> This section is for my personal laptop only. Do not run it on my work laptop, which has its own `.zshrc`.

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

## Personal shell config

On a personal Mac, chezmoi manages `.zshrc` and `.zprofile`. On a work Mac, both
files are ignored and left unchanged.

The personal config loads Homebrew, oh-my-zsh, fzf, powerlevel10k, and
zsh-syntax-highlighting. It also loads `.p10k.zsh` if present and sources
`.path`, `.exports`, `.aliases`, and `.extra` when they exist. `.zprofile` adds
the VSCode command-line tool to PATH.

Install oh-my-zsh using the section above before applying the personal config.
On the first apply, compare your current shell files with `chezmoi diff` and
move any personal additions you want to keep into `~/.extra`. Do not add the old
source loop to `.zprofile` or `.bashrc`; `.zshrc` now loads those files for
interactive zsh sessions.

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
