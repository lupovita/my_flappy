# Agent contribution workflow

Use the alignment-first, issue-driven GitHub Flow for every feature, bug fix, or other planned change.

## Align on human intent first

Before creating an issue, branch, worktree, or changing files, hold a brainstorming session between the human and agent. Use it to establish a shared understanding of:

- the problem to solve, intended outcome, and why it matters;
- the desired scope, constraints, and explicit exclusions; and
- observable success criteria and any important trade-offs.

Do not begin implementation until the human and agent explicitly agree on that intent. Once aligned, turn the agreed outcome into the GitHub issue contract below. If new information changes the intent later, pause to realign with the human and update the issue before expanding the work.

## Issue is the contract after alignment

Before creating a feature branch or changing files, create or identify a GitHub issue with `gh issue`. The issue must describe:

- **Feature:** what will be built or changed and why.
- **Scope:** what is included and explicitly excluded.
- **Success criteria:** observable acceptance checks that determine when the work is complete.

Treat the issue as the contract between the human and the agent. If the requested work is not covered by the issue, update the issue or ask for clarification before expanding scope. Link the issue from all related commits and the pull request.

## Branches and pull requests

- Keep branches short-lived and focused on one issue.
- Branch from the current `main` (after fetching it) using `feature/<issue-number>-<short-slug>` for features, `fix/<issue-number>-<short-slug>` for bugs, or another equally explicit type when appropriate.
- Create an isolated Git worktree for the issue branch before implementation; use the code-and-local-test loop there until the issue success criteria are met.
- Do not work directly on `main`.
- Keep commits focused, link them to the issue, and push the branch.
- Open a pull request with `gh pr create --base main`, linking the issue and restating the success criteria. The PR is the review and delivery boundary.
- Before opening or updating the PR, run the relevant tests/checks and report their results in the PR.
- Address CI failures and review feedback on the same branch. Merge only through the approved, reviewed PR after required CI checks pass. Do not force-push shared branches or bypass required checks.

## Post-merge cleanup

After the PR has merged into `main`:

1. In the primary workspace, fetch `origin/main`, switch to `main` if necessary, and fast-forward it to the latest `origin/main`.
2. Verify the completed issue worktree has no uncommitted changes, then remove it with `git worktree remove <worktree-path>`.

Do not force-remove a dirty worktree. Stop and preserve its changes until the human decides how they should be handled.

When `main` does not exist yet, stop and report the repository state rather than silently substituting another branch; the human should decide whether to establish or rename the default branch.

## Isolated agent handoffs

- All agent implementation work and handoffs must use a Git worktree below `worktrees/`, such as `worktrees/feature-123-short-slug`.
- Create the worktree on the issue branch and state its exact path and branch when handing work to another agent. This keeps the root workspace on `main` clean while allowing agents to inspect and navigate sibling worktrees.
- Do not commit worktree contents. `.gitignore` excludes `worktrees/*` while retaining `worktrees/.gitkeep` so the shared handoff directory exists after checkout.
