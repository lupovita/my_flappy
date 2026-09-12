---
name: github-flow
description: Use an issue-driven GitHub Flow for repository changes: create an issue contract, make a short-lived focused branch, and deliver through a pull request into main.
---

# Issue-driven GitHub Flow

Apply this workflow to every feature, bug fix, refactor, or other planned repository change.

## Required contract

Before creating a branch or editing files, identify an existing issue or prepare a new issue contract that explicitly contains:

- **Feature:** the desired outcome and user value.
- **Scope:** what is included and excluded.
- **Success criteria:** observable checks for completion.

For a new issue, preserve its Markdown formatting by following this sequence:

1. Draft the complete body in an ignored file named `.tmp/<issue>.md`, where `<issue>` is a descriptive, lower-kebab-case issue slug (for example, `.tmp/add-login.md`).
2. Create the issue with `gh issue create --title "<title>" --body-file .tmp/<issue>.md`. Do not pass the issue body as an inline `--body` argument.
3. Record the created issue number, then use that issue as the contract for all subsequent work.

The issue is the contract between the human and the agent. If the requested work exceeds the issue, update the issue or pause for clarification. Link the issue in commits and the pull request (for example, `Closes #123` when the PR should close it).

## Branch and PR workflow

1. Fetch the repository and branch from `main`; do not make feature changes directly on `main`.
2. Create a short-lived branch named `feature/<issue-number>-<short-slug>` or `fix/<issue-number>-<short-slug>`, then create a Git worktree for it under `worktrees/` (for example, `worktrees/feature-123-short-slug`). Do all implementation work in that worktree, not in the root workspace.
3. For an agent handoff, provide the issue number, branch name, and exact worktree path. Sibling worktrees remain readable and navigable from the shared workspace.
4. Implement only the issue scope, keeping commits focused and easy to review.
5. Run relevant tests, linters, and checks. Add or update tests when success criteria require them.
6. Push the branch and open a PR targeting `main` with `gh pr create --base main`. Include the issue link, summary, test results, and a checklist showing each success criterion.
7. Address review feedback on the same branch. Merge only through the reviewed PR after required checks pass.

If `main` is absent, do not silently use another branch; report the repository state and ask the human to establish or rename the default branch. Do not force-push shared branches or bypass required checks.

The repository's `.gitignore` must exclude `worktrees/*` while preserving `worktrees/.gitkeep`; never add an agent's worktree contents to version control.

The repository's `.gitignore` must also exclude `.tmp/`; never add temporary issue drafts to version control.
