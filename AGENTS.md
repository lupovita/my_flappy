# Agent contribution workflow

Use the issue-driven GitHub Flow for every feature, bug fix, or other planned change.

## Issue is the contract

Before creating a feature branch or changing files, create or identify a GitHub issue with `gh issue`. The issue must describe:

- **Feature:** what will be built or changed and why.
- **Scope:** what is included and explicitly excluded.
- **Success criteria:** observable acceptance checks that determine when the work is complete.

Treat the issue as the contract between the human and the agent. If the requested work is not covered by the issue, update the issue or ask for clarification before expanding scope. Link the issue from all related commits and the pull request.

## Branches and pull requests

- Keep branches short-lived and focused on one issue.
- Branch from the current `main` (after fetching it) using `feature/<issue-number>-<short-slug>` for features, `fix/<issue-number>-<short-slug>` for bugs, or another equally explicit type when appropriate.
- Do not work directly on `main`.
- Keep commits focused and explain meaningful behavior changes.
- Open a pull request with `gh pr create --base main`, linking the issue and restating the success criteria. The PR is the review and delivery boundary.
- Before opening or updating the PR, run the relevant tests/checks and report their results in the PR.
- Merge only through the reviewed PR. Do not force-push shared branches or bypass required checks.

When `main` does not exist yet, stop and report the repository state rather than silently substituting another branch; the human should decide whether to establish or rename the default branch.
