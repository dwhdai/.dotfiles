---
name: new-project
description: Create a new project folder in Obsidian vault with an initialized changelog. Use when the user wants to start a new project.
user-invocable: true
argument-hint: <project-name>
---

# New Project

Create a new project folder in the user's Obsidian vault and initialize it with a changelog.

## How to use arguments

- `$ARGUMENTS` contains the project name
- The project name is required -- ask the user if not provided
- The project name is used as the folder name in the Obsidian vault

## Steps

### 1. Parse the project name

Extract the project name from `$ARGUMENTS`. If no project name is provided, ask the user for one.

### 2. Create the project folder

Create a new folder in the Obsidian vault at `/users/daviddai/obsidian-vault/<project-name>/`.

If the folder already exists, warn the user and ask how they want to proceed.

### 3. Initialize changelog.md

Create a `changelog.md` file in the new project folder with the following format:

```markdown
# <project-name> Changelog

## <today's date in YYYY-MM-DD format>

- Project created
```

### 4. Confirm completion

Tell the user the project folder and changelog have been created, and show the path to the new folder.
