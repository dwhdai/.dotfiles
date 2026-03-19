---
name: git-worktree-init
description: Set up a git repository using the bare repository + worktrees approach for parallel branch development. Use when the user wants to initialize worktrees for a project.
user-invocable: true
argument-hint: <git-remote-url> [worktree-directory-name]
---

# Git Worktree Init (Bare Repository Approach)

Set up a git repository using a bare clone with worktrees for parallel development. This allows working on multiple branches simultaneously without stashing or switching.

## How to use arguments

- `$ARGUMENTS` contains the full argument string
- First argument: the git remote URL (e.g. `git@github.com:org/repo.git`)
- Second argument (optional): the parent directory name (defaults to the repo name)

## Steps

### 1. Determine the project details

Parse the arguments to extract:
- The git remote URL (required — ask the user if not provided)
- The parent directory name (default: derive from the repo URL, e.g. `annotations-library` from `git@github.com:org/annotations-library.git`)

Ask the user where they want the worktree parent directory created if not obvious from context.

### 2. Create the parent directory and bare clone

```bash
mkdir <parent-dir> && cd <parent-dir>
git clone --bare <remote-url> .bare
```

### 3. Create the gitdir pointer

Create a `.git` **file** (not directory) that points to the bare repo:

```bash
echo "gitdir: ./.bare" > .git
```

This lets tools (VS Code, shell prompts) recognize the parent as a repo root without making it a working tree.

### 4. Configure remote fetch

Bare clones only track HEAD by default. Fix this to fetch all branches:

```bash
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin
```

### 5. Create the main worktree

```bash
git worktree add main main
```

### 6. Ask the user if they want additional worktrees

Offer to create worktrees for existing remote branches or new branches. For each:

- **Existing branch:** `git worktree add <directory-name> <branch-name>`
- **New branch off main:** `git worktree add <directory-name> -b <new-branch-name> main`

### 7. Show the final structure

Display the resulting directory layout and remind the user:

- Each worktree needs its own virtual environment (`poetry install`, `npm install`, etc.)
- Never check out the same branch in two worktrees
- Useful commands:
  - `git worktree list` — show all worktrees
  - `git worktree add <dir> <branch>` — add a new worktree
  - `git worktree remove <dir>` — remove a worktree
  - `git worktree prune` — clean up stale references
