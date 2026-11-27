# dotfiles

My macOS dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

| Topic                            | File                                     |
| -------------------------------- | ---------------------------------------- |
| Personal vs work Macs, git email | [docs/machines.md](docs/machines.md)     |
| Per-app setup                    | [docs/apps.md](docs/apps.md)             |
| Agent-led Mac setup              | [macbook-setup skill](.claude/skills/macbook-setup/SKILL.md) |

## 1. Install brew and chezmoi

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Accept the Xcode command line tools prompt, wait for it to finish, then add
Homebrew to your `$PATH` as the installer shows, for example:

```bash
echo >> ~/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi
```

## 2. Install the dotfiles

Clone the repo where you want to edit it, and use that folder as chezmoi's
source:

```bash
git clone https://github.com/tonywu71/dotfiles.git ~/code/personal/dotfiles
chezmoi init --source ~/code/personal/dotfiles
```

`chezmoi init` asks whether this is your personal Mac. Answer no on a work Mac.

> [!IMPORTANT]
> Before the first `chezmoi apply`, run `gh auth login` (GitHub HTTPS auth goes
> through `gh`). On a work Mac, also create `~/.gitconfig.local` with your work
> email, or work commits will use the personal one. See
> [docs/machines.md](docs/machines.md).

```bash
chezmoi diff
chezmoi apply
```

`chezmoi diff` and `chezmoi apply` read your edits directly, so you do not need
to push before applying.

## 3. Install apps

Sign in to the Mac App Store first. `brew bundle` uses `mas` for App Store apps
and fails if you are signed out.

```bash
chezmoi cd  # the folder with the Brewfile
brew bundle
```

Then follow [docs/apps.md](docs/apps.md) for the apps that need extra steps.

## Agent-led setup

In Claude Code, run `/macbook-setup` from this repo, or ask to set up your
personal Mac. Other agents find the same skill through `AGENTS.md`. The skill
reads the [MacBook Setup page in Notion](https://app.notion.com/p/tonywu71/MacBook-Setup-f1d68e10c55f4f479b72583c8f72416b),
lists what is missing, and suggests Notion fixes without editing Notion unless
you ask. `chezmoi apply` only updates dotfiles. Installing packages stays an
explicit `brew bundle` step.

## Checks

```bash
zsh -n dot_zprofile
zsh -n dot_zshrc
chezmoi diff  # review before applying
```

<details>
<summary>Notes: <code>~/.extra</code>, <code>~/.env</code>, Rosetta</summary>

- Put machine-specific shell config in `~/.extra`. `.zshrc` sources it if it
  exists.
- Put secrets in `~/.env` and source it only when needed. Give API keys the
  fewest permissions they need.
- Install Rosetta if an app needs it:

  ```bash
  softwareupdate --install-rosetta
  ```

</details>
