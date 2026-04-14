---
name: implement
description: Implement a plan step-by-step, generating small amounts of code at a time and asking for feedback intermittently. Use when the user is ready to implement a specific plan or design.
user-invocable: true
---

# Implement

Implement the current plan incrementally, collaborating with the user at each step.

## Principles

- **Small steps**: Write the minimum code needed for one logical step at a time. Never implement an entire feature in one go.
- **High to low level**: Start with the top-level structure (interfaces, types, function signatures, module layout) before filling in implementation details.
- **Feedback loops**: After each step, pause and ask the user for feedback before continuing. Do not proceed to the next step until the user confirms.
- **Show your thinking**: Before writing code, briefly explain what you're about to do and why. Keep it to 1-2 sentences.

## Process

1. **Restate the plan**: Briefly summarize the plan you're about to implement. Ask the user to confirm or adjust before writing any code.
2. **Break it down**: List the implementation steps you intend to follow, ordered from high-level structure to low-level details.
3. **Implement one step at a time**:
   - Explain what this step does (1-2 sentences).
   - Write the code for just this step.
   - Ask: "How does this look? Should I adjust anything before moving on?"
4. **Incorporate feedback**: If the user suggests changes, apply them before moving to the next step.
5. **Repeat** until the plan is fully implemented.

## Rules

- Never skip ahead or batch multiple steps together, even if the implementation seems obvious.
- If the user says "keep going" or "looks good", proceed to the next step only.
- If at any point the plan needs to change, re-align with the user on the updated plan before continuing.
- Prefer editing existing files over creating new ones.
