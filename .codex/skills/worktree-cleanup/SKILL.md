---
name: worktree-cleanup
description: Safely find and remove local Git worktrees whose feature branches have already merged into main. Use after merged pull requests or when local worktree directories need cleanup; do not use for unmerged or active work.
---

# Worktree cleanup

Run `scripts/cleanup-merged-worktrees.ps1` from any worktree in this repository.

- With no arguments, it is a read-only dry run that lists eligible worktrees.
- To remove one eligible worktree, pass its exact path with `-WorktreePath` and `-Apply`.
- The helper only accepts worktrees below this repository's `worktrees/` directory whose local branch is already an ancestor of `main`.
- It refuses `main`, the primary worktree, unmerged branches, and unknown paths. It does not force removal, so Git protects dirty worktrees.

Example:

```powershell
.\.codex\skills\worktree-cleanup\scripts\cleanup-merged-worktrees.ps1
.\.codex\skills\worktree-cleanup\scripts\cleanup-merged-worktrees.ps1 -WorktreePath 'C:\path\to\repo\worktrees\feature-123-example' -Apply
```
