# AGENTS.md

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io/). `dot_<name>` renders to `~/.<name>`. A `.tmpl` suffix marks a chezmoi template (e.g. `dot_gitconfig.tmpl`).

- Edit sources here, not the files in `~`. Preview with `chezmoi diff`, then `chezmoi apply`.
- `Brewfile`: one block per type (`tap`, `brew`, `cask`, `mas`), blank line between blocks, alphabetical within a block.
- Conventional commits, one change per commit. Commit straight to `main`, no branches or PRs.
- Never commit secrets or work data: no keys, tokens, passwords, internal
  hostnames, IPs, cluster names, or work URLs. Keep them in `~/.extra`,
  `~/.gitconfig.local`, or other local-only files.
- Before committing, check the diff for any of the above.

## Machine setup

- For requests to set up, update, or audit the personal Mac, read and follow
  [macbook-setup](.claude/skills/macbook-setup/SKILL.md).
- Personal setup requires `personal = true` on the target Mac. Keep work Macs
  at `personal = false` and preserve their shell files and settings.
- Repo-only changes do not authorize setup on the current Mac.
- This repo does not install agent skills. My own skills and the third-party
  skills for Codex and Cursor (`setup-other-agents.sh`) live in the
  [skills repo](https://github.com/tonywu71/skills), cloned at
  `~/.claude/skills`. For any skills question or setup step that is missing
  here, read `~/.claude/skills/README.md` first.
