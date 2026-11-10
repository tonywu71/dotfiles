# Workflow

- Follow the repository's local instructions and established style when they conflict with this file.
- Make routine judgment calls yourself and state the assumption.
- Ask me first when: the work touches a live training run or anything irreversible, two readings of my request imply materially different work, or I've asked for something whose premise looks wrong.
- For changes spanning several files, lay out the steps before editing. For a one-line fix, just make it.
- When you ask: describe the situation and the options in the chat FIRST, then use `AskUserQuestion`. Never open with a bare tool call; I want the reasoning before the menu.

# Explanations

- Always trigger the /humanizer skill at the start of the conversation.
- Use simple words and short sentences.
- Explain each non-trivial idea with the smallest useful example.
- For a proposed fix, show the behavior before and after the fix.
- Keep examples focused on one idea. Remove unrelated setup.
- Give one good example instead of several similar examples.

# Python Style

- Trigger the /ponytail skill as soon as we work on code. Never write `ponytail:` comments in code, even though the skill asks for them.
- Maximize simplicity and readability. Prefer simpler code over slightly faster code. Write the simple version first and mention the faster option in the chat.
- Strip edge cases in the first lines of each function with early-return `if` blocks.
- Split a function when it handles more than one clear task or is hard to read in one pass.
- Create a class only if it holds state. If it has no attributes, make its methods plain functions.
- Avoid `from __future__ import annotations` when possible.
- Do NOT use unnecessary try/except. Let errors propagate unless you can actually handle them.
- Type every function argument and return value.
- Type local variables when the type is unclear or helps the type checker.
- Prefer explicit variable names over short ones, unless the repo's own conventions say otherwise.
- Comments explain WHY and default to none: only when the logic is genuinely complex, and usually one short line.

## Private helpers

- Private functions: prefix with `_` and put them at the TOP of the module.
- Private methods: prefix with `_` and put them at the END of the class.
- Apply both even when the surrounding file doesn't, unless the repo's own conventions say otherwise.

# Verifying

- Use the project's own toolchain (`uv run …` where the repo uses uv), not a global interpreter.
- Run the smallest relevant tests and type checks after each change.
- Run the full test suite when the change has broad effects.
- State what you ran. If you could not run a check, state why.
- Do not say "done" unless the checks you ran passed.

# Git & GitHub

- Do not co-author my commits.
- Never mention Claude or AI in PR descriptions or comments.
- Atomic conventional-commit commits.
