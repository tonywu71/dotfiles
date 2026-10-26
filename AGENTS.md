# AGENTS.md

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). `dot_<name>` renders to `~/.<name>`. A `.tmpl` suffix marks a chezmoi template (e.g. `dot_gitconfig.tmpl`).

- Edit sources here, not the files in `~`. Preview with `chezmoi diff`, then `chezmoi apply`.
- `Brewfile`: one block per type (`tap`, `brew`, `cask`, `mas`), blank line between blocks, alphabetical within a block.
- Conventional commits, one change per commit. Commit straight to `main`, no branches or PRs.
- No secrets, no work-specific config.

## Machine setup

- When the user asks to set up a Mac, first inspect what is already installed
  without changing anything. Read `Brewfile`, `README.md`, and the personal
  Notion [MacBook Setup](https://app.notion.com/p/tonywu71/MacBook-Setup-f1d68e10c55f4f479b72583c8f72416b)
  page, including linked setup pages, nested toggles, screenshots, and relevant
  settings exports. Do not use pages from a work workspace as a substitute. If the
  personal page cannot be read, report the access problem before proceeding
  with setup based on Notion.
- Before installing anything or changing settings, give the user a list of
  what should be installed. Include command-line tools, apps, shell plugins,
  and editor/browser extensions from those sources. Distinguish what is
  installed, missing, or could not be checked. List logins, licenses, and other
  steps that need the user's input separately. Explain the proposed settings
  changes too.
- Confirm which Mac is being set up. Personal shell files and Notion settings
  are for the personal Mac only. Keep `personal = false` on work Macs and leave
  their shell files and settings unchanged. Reading or editing this repo is
  not a request to install packages or apply settings on the current Mac.
- Perform the requested setup with commands or temporary scripts written for
  that session. Prefer scripts when there is a reliable way to make the change.
  Use Computer Use if available when scripting is unsuitable. If neither is
  available, explain the remaining manual steps. Check current app/macOS
  versions, preserve unrelated settings, and verify each change afterward.
- Keep `brew bundle` an explicit installation step. Do not add persistent setup
  scripts, chezmoi run scripts, or copies of Notion's extension/settings lists
  to the repo unless the user asks. Managed shell startup files are still
  chezmoi configuration.
- If a setting has a different name from the one in Notion, warn the user.
  Show the old name and current name, explain whether they have the same
  behavior, and suggest the exact Notion wording to update. If the mapping is
  uncertain or the setting was removed, leave it unchanged and ask the user.
  Treat conflicting instructions the same way. Do not edit Notion unless the
  user explicitly asks.
- Report what was installed or changed, what was verified, and what remains.
  Never include passwords, tokens, or private keys in reports or the repo.
