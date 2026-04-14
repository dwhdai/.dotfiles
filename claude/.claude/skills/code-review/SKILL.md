---
name: code-review
description: Code review a pull request
user-invocable: true
argument-hint: <pr-url>
---

# Code Review

Review a GitHub pull request, comparing it against main.

## How to use arguments

- `$ARGUMENTS` contains the full GitHub PR URL (e.g. `https://github.com/org/repo/pull/123`)
- The PR URL is required -- ask the user if not provided

## Steps

### 1. Parse the PR URL

Extract the owner, repo name, and PR number from `$ARGUMENTS`. The URL format is `https://github.com/<owner>/<repo>/pull/<number>`. If no URL is provided or the format is invalid, ask the user for one.

### 2. Clone or navigate to the repository

If the current working directory is not the target repository, clone it to a temporary location or use `gh` commands with the `--repo <owner>/<repo>` flag to operate remotely.

### 3. Ensure main is up to date

Run `git fetch origin main` to make sure main is current before comparing.

### 4. Gather PR information

Use `gh` CLI to get PR details, specifying the repo explicitly:

```
gh pr view <number> --repo <owner>/<repo> --json title,body,baseRefName,headRefName,files,url
gh pr diff <number> --repo <owner>/<repo>
```

### 5. Identify the repository

Determine which repository this PR belongs to based on the parsed URL. This affects the review criteria applied.

### 5. Review the diff

Review all changed files in the PR diff against main. For every repository, assess:

- **Correctness**: Logic errors, edge cases, off-by-one errors
- **Readability**: Clear naming, understandable flow, appropriate comments
- **Testing**: Are changes adequately tested? Are edge cases covered?
- **Security**: Injection risks, credential exposure, unsafe operations

### 6. Apply annotations-library-specific criteria (if applicable)

If the repository is `annotations-library` (or the PR is in an annotations-related repo), apply these additional critical review criteria:

#### Do not recreate existing functionality
- Search the codebase for existing implementations before accepting new code
- Flag any new utility functions, helpers, or classes that duplicate what already exists
- Suggest using the existing implementation instead

#### Use existing classes and utilities
- Check whether new code leverages existing base classes, mixins, and shared utilities
- Flag cases where the author wrote something from scratch that could extend or compose existing abstractions

#### Identify candidates for generalization
- Look for functionality that is implemented narrowly but could benefit other parts of the repo
- Suggest refactoring opportunities where a pattern could be extracted into a shared utility

#### CRITICALLY assess backwards compatibility

This is the highest-priority concern for annotations-library PRs. There are two categories of breaking changes:

**A. Output entity definition changes**

Modification, removal, or addition of a field to an existing entity that prevents safe re-instantiation of existing data generated from the previous entity definition is NOT backwards compatible.

- Flag any changes to entity field definitions (additions, removals, type changes, renames)
- Ask: "Can existing serialized entity data be deserialized using the new definition?"
- If uncertain, recommend the author test using the backwards compatibility procedure:
  1. Find a case on rdprod-evals with an existing CLP snapshot from the previous entity definition
  2. Verify the active snapshot on the test case (snapshot id `e814cd13-849e-49e2-acd7-d7f73c54108b` on matter `3d3f514e-d0e9-4b7a-94da-b9a7abd85025`)
  3. Request an Express Demand and check the `extract_source_of_truth` workflow for deserialization errors
- Reference past incident: https://evenup.atlassian.net/wiki/spaces/eng/pages/646807555/2025-10-03+-+Generate+sot+can+t+deserialize+entities+XD+failure+on+Billing+v6+rollout

**B. FLP output structure changes**

Modification of FLP output or how that output is accessed/used downstream within CLP, such that the new CLP code is incompatible with existing older FLP outputs, is NOT backwards compatible.

- Flag any changes to transform FLP output structures
- Flag any changes to how FLP outputs are processed in subsequent FLP transforms or in CLP
- If uncertain, recommend the author test using the backwards compatibility procedure:
  1. Identify a case with existing FLP outputs in the previous format
  2. Re-trigger CLP with the new changes to verify it can process the older FLP outputs
  3. If unsure whether existing FLP outputs exist, create a new case, run FLP/CLP with the current release branch, then switch to the PR branch and re-trigger

### 7. Present the review

Structure the review as:

```
## PR Review: <PR title>
<PR URL>

### Summary
<Brief summary of what the PR does>

### Backwards Compatibility Assessment (annotations-library only)
<Assessment of backwards compatibility risks, or "N/A" if not annotations-library>

### Issues Found
For each issue:
- **[severity: critical/warning/nit]** <file>:<line> - <description>

### Suggestions
<Optional suggestions for improvement>

### Verdict
<APPROVE / REQUEST_CHANGES / NEEDS_DISCUSSION> with brief justification
```
