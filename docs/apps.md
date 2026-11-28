# App setup

Steps that `brew bundle` and `chezmoi apply` do not cover on their own.

## brew

Upgrade all formulae and casks and run `cleanup` once a week. Newer brew
refuses commands from taps you have not trusted, so trust the tap first:

```bash
brew trust domt4/autoupdate
brew autoupdate start 604800 --cleanup --upgrade
brew autoupdate status  # should say "installed and running"
```

## Claude Code

Install with the native installer, not brew. It updates itself in the
background, while the `claude-code` cask needs `brew upgrade`:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Then clone my [skills](https://github.com/tonywu71/skills) repo as
`~/.claude/skills`, where Claude Code looks for user skills. chezmoi does not
manage this folder, so update it with `git pull`:

```bash
git clone https://github.com/tonywu71/skills.git ~/.claude/skills
```

`chezmoi apply` sets the keys in `agents/claude-settings.json` in
`~/.claude/settings.json`: output style, UI, permission mode, plugins, and
plugin marketplaces. Other keys stay as they are, such as the model, hooks, and
`autoMode`. My [Session Compass](https://github.com/tonywu71/session-compass)
mod is one of the plugins and needs Claude Code 2.1.287 or later. If a plugin
does not load on a new Mac, install it with `/plugin`.

> [!WARNING]
> `chezmoi apply` replaces each top-level key as a whole, so `enabledPlugins`,
> `extraKnownMarketplaces`, and `permissions` end up exactly as in the repo. A
> plugin installed with `/plugin` but missing from
> `agents/claude-settings.json` gets turned off on the next apply. This
> matters most on a work Mac, which likely has extra work plugins. Never add
> work plugins or marketplaces to the repo. Turn them back on with `/plugin`
> after each apply instead.

## Codex

Install with the `codex` cask from the Brewfile, not the install script. The
script install only tells you about new versions and waits for `codex update`.
The cask gets upgraded each week by brew autoupdate.

`chezmoi apply` sets "Approve for me" as the default permission mode in
`~/.codex/config.toml` (`approval_policy`, `approvals_reviewer`,
`sandbox_mode`) and keeps every other key. It also links `~/.codex/AGENTS.md`
to `~/.claude/CLAUDE.md`, so Codex reads the same instructions.

## GitHub

Log in with `gh`:

```bash
gh auth login
```

Add an SSH key for GitHub to the `ssh-agent` using this
[guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

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

Add the new key to the Apple Keychain (if applicable):

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Then add the key at <https://github.com/settings/keys>, following this
[tutorial](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

## Herdr

`brew bundle` installs Herdr.app with the `herdr-app` cask, and the app installs
herdr-core (`hc`) itself. If Herdr.app was installed by hand in
`~/Applications`, remove it first, or brew adds a second copy in
`/Applications`. The `herdr` formula is the older terminal multiplexer, a
separate tool.

`chezmoi apply` sets up the same look as iTerm2:

- `~/.config/herdr-app/themes/snazzy.json` holds the Snazzy colors, converted
  from the iTerm2 preset.
- `~/.config/herdr-app/settings.json` gets `theme`, `font` (MesloLGS NF),
  `font_size` (13) and `font_weight` (400). Herdr also writes to this file, so
  chezmoi sets only these four keys and keeps the rest. Herdr's default weight
  is 500, which looks bolder than iTerm2. Size 13 in Herdr looks the same as
  size 14 in iTerm2.

To change one of these keys, edit `dot_config/herdr-app/modify_settings.json`.
It leaves the file untouched when the keys already match, so `chezmoi diff`
stays clean after Herdr rewrites the file.

A theme or text size picked in the Herdr UI is saved in
`~/.config/herdr-app/layouts/.state/` and wins over `settings.json`. Don't edit
`.state` by hand. To set the theme from a shell, run
`herdr-app do app.theme --name snazzy`.

### Cmd+W confirmation

`Cmd+W` asks before it closes a tab that has more than one pane. A tab with one
pane closes at once. Two files set this up:

- `~/.config/herdr-app/mods/ask-close-tab/` is a small mod. It counts the panes
  in the focused tab. With one pane it closes the tab. With more, it opens
  Herdr's own `confirm` dialog, where Enter closes the tab and Esc cancels.
- `~/.config/herdr-app/keys.json` gets `"cmd-w": "mod.open:ask-close-tab"`.
  Herdr writes this file too, so `dot_config/herdr-app/modify_keys.json` sets
  only this key and keeps the rest.

On a new Mac, open Herdr once before `chezmoi apply`. Herdr writes its default
`keys.json` on the first start. Until that file exists, chezmoi leaves it alone,
because a file with only `Cmd+W` would replace all of Herdr's default shortcuts.
Run `chezmoi apply` again after the first start to add the key.

The × button on a tab and Close in its right-click menu still close without
asking. To turn the confirmation off, set `cmd-w` back to `tab.close` in
`modify_keys.json`.

Run `/herdr` in Claude Code to change Herdr with an agent.

## inshellisense

`brew bundle` installs it from the `microsoft/inshellisense` tap. If you skipped
`brew bundle`, install it directly:

```bash
brew tap microsoft/inshellisense https://github.com/microsoft/inshellisense
brew install inshellisense
```

Then generate the shell resources once and check the setup. `dot_zshrc` already
sources the zsh hook as its last line, and `chezmoi apply` installs the settings
from `dot_config/inshellisense/rc.toml` (Nerd Font icons, Snazzy blue highlight,
rounded box, alias expansion).

```bash
is init zsh
is doctor
```

After `brew upgrade inshellisense`, run `is reinit`.

## iTerm2

`chezmoi apply` installs a dynamic profile, `Dotfiles`, at
`~/Library/Application Support/iTerm2/DynamicProfiles/profiles.json` and makes
it the default. It holds the font, the
[Snazzy](https://github.com/sindresorhus/iterm2-snazzy) colors, and the key
mappings. iTerm2 Settings cannot edit a dynamic profile, so change the JSON
instead. The global iTerm2 settings (tmux and tabs) are in
`run_onchange_after_app-defaults.sh.tmpl`.

## tmux

I run Claude Code sessions inside tmux with iTerm2's control mode, so the panes
and sessions survive quitting iTerm2. `chezmoi apply` installs `~/.tmux.conf`
and the `t` and `tp` aliases in `~/.aliases`.

```bash
t   # attach to the "main" session, or create it
tp  # list every pane with its title and folder
```

- Quit iTerm2 with `Cmd+Q` to detach. `Cmd+W` on a tab kills that tmux window.
- A reboot stops tmux. Run `claude --resume` in each worktree to get the
  conversations back.
- After editing `~/.tmux.conf`, run `tmux source ~/.tmux.conf`. Restart Claude
  Code sessions to pick up the new environment.
