# Personal and work Macs

## The `personal` flag

`chezmoi init` asks whether this is your personal Mac. Answer no on a work Mac.
The answer is saved in `~/.config/chezmoi/chezmoi.toml`, outside this repo:

```toml
[data]
personal = false
```

`personal` is our custom variable in chezmoi's built-in config file. It defaults
to false. Personal shell files require `personal = true` and macOS. An agent
applying personal Notion settings must also check this flag. Work Macs keep
their existing `.zshrc` and `.zprofile`. The shared `.aliases` and `.gitconfig`
are still managed on both kinds of Mac.

For an existing checkout, run `chezmoi init` to generate the local config, then
review `chezmoi diff` before applying anything. Changing the local value later
does not undo settings that were already applied.

## `chezmoi re-add` on a work Mac

Always name the file, for example `chezmoi re-add ~/.claude/CLAUDE.md`. Work
Macs are often not fully applied, so some home files are older than the repo. A
bare `chezmoi re-add` would copy those older files into the repo.

## Git email on a work Mac

`chezmoi apply` writes the same `~/.gitconfig` on every Mac, with the personal
GitHub noreply email. Its last lines include `~/.gitconfig.local`. Git reads
that file last, so its values win. Git skips the include when the file is
missing.

| Mac      | `~/.gitconfig.local` | Commits use   |
| -------- | -------------------- | ------------- |
| Personal | missing              | noreply email |
| Work     | sets the work email  | work email    |

On a work Mac, create the file before the first `chezmoi apply`. Otherwise your
work commits use the personal email:

```bash
git config -f ~/.gitconfig.local user.email <work-email>
chezmoi apply
git config user.email  # should print the work email
```

Keep `~/.gitconfig.local` out of this repo. Put any other git setting that
belongs to one Mac only in the same file.

## Personal shell config

On a personal Mac, chezmoi manages `.zshrc` and `.zprofile`. On a work Mac, both
files are ignored and left unchanged.

The personal config loads Homebrew, oh-my-zsh, fzf, powerlevel10k, and
zsh-syntax-highlighting. It also loads `.p10k.zsh` if present and sources
`.path`, `.exports`, `.aliases`, and `.extra` when they exist. `.zprofile` adds
the VSCode command-line tool to PATH.

Install oh-my-zsh before applying the personal config. Personal Mac only, since
a work Mac has its own `.zshrc`:

```bash
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

On the first apply, compare your current shell files with `chezmoi diff` and
move any personal additions you want to keep into `~/.extra`. Do not add the old
source loop to `.zprofile` or `.bashrc`; `.zshrc` now loads those files for
interactive zsh sessions.
