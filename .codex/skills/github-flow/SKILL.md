---
name: github-flow
description: Use an issue-driven GitHub Flow for repository changes: create an issue contract, make a short-lived focused branch, and deliver through a pull request into main.
---

# Issue-driven GitHub Flow

Apply this workflow to every feature, bug fix, refactor, or other planned repository change.

## Required contract

Before creating a branch or editing files, use `gh issue create` or identify an existing issue that explicitly contains:

- **Feature:** the desired outcome and user value.
- **Scope:** what is included and excluded.
- **Success criteria:** observable checks for completion.

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
