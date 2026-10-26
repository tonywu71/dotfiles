---
name: macbook-setup
description: Set up or update Tony's personal Mac using the dotfiles repo and personal Notion MacBook Setup page. Use when asked to install the personal setup, configure its apps or macOS preferences, or compare the Mac with the setup guide. Do not apply the setup for repo-only edits or on a work Mac.
---

# MacBook setup

Use the current personal setup guide to inspect the Mac, explain the proposed
changes, and perform the setup the user requested. Keep this skill as
instructions only. Create temporary scripts during a setup session when useful.

## Read the setup sources

Find the dotfiles repo from the current project or chezmoi source directory.
The usual location is `~/code/personal/dotfiles`. Read its `AGENTS.md`,
`README.md`, and `Brewfile`.

Read the personal Notion [MacBook Setup](https://app.notion.com/p/tonywu71/MacBook-Setup-f1d68e10c55f4f479b72583c8f72416b)
page, including linked setup pages, nested toggles, screenshots, and relevant
settings exports. The page ID is `f1d68e10c55f4f479b72583c8f72416b`.
Use the personal workspace, previously named `Personal (Tony)`, associated with
`tonywu71`. Never substitute pages from a work workspace such as H-Co.
If the personal page or a needed section cannot be read, report what is missing
and stop the setup steps that depend on it. Do not guess missing settings.

Use Notion for desired preferences and extensions, and the repo for managed
dotfiles and packages. Do not copy extension lists or settings inventories into
the repo. Inspect exports for secrets and machine-specific paths before using
them; restore only the intended preferences.

## Inspect and explain before changing anything

Establish which Mac is the target from the conversation and local configuration.
Personal setup requires macOS and `personal = true` in the local chezmoi config.
If the target is unclear, ask. Never change that flag merely to bypass the
check. Leave work Macs with `personal = false` and preserve their shell files
and preferences. Editing this repo or this skill does not authorize setup on
the current Mac.

Inspect installed software and current settings without changing them. Before
installing anything or changing settings, give the user an installation list
covering the requested command-line tools, apps, shell plugins, and editor or
browser extensions. Mark each as installed, missing, or not checked. Separate
logins, licenses, and other steps requiring user input, and explain the proposed
settings changes. If the request is only an audit or a plan, stop after reporting.

## Perform the requested setup

Prefer commands or temporary scripts when they can reliably make the change.
Use Computer Use if available when scripting is unsuitable. If neither method
is available, explain the remaining manual steps. Check the current macOS and
app versions, preserve unrelated settings, and verify each change afterward.
Keep changes within the user's requested scope.

Keep `brew bundle` an explicit installation step. Do not add persistent setup
scripts or chezmoi run scripts unless the user asks. Managed shell startup files
remain chezmoi configuration. Before applying them, preview the diff and
preserve any existing personal additions. Do not overwrite existing SSH keys
or include passwords, tokens, or private keys in reports or the repo.

When a setting differs from Notion, warn the user before changing it. Show the
old name and the current name, explain whether their behavior matches, and
suggest the exact Notion wording to update. If the mapping is uncertain, the
setting was removed, or the instructions conflict, leave that setting unchanged
and ask the user. Do not edit Notion unless the user explicitly asks.

Report what was installed or changed, what was verified, what still needs the
user's input, and any suggested Notion corrections.
