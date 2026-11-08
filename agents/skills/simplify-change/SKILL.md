---
name: simplify-change
description: Simplify selected working code for clarity and maintainability while preserving observable behavior. Use for requested refactoring or simplification, not speculative cleanup during other tasks.
---

# Simplify change

Reduce complexity within the requested scope without changing behavior.

- Read project conventions, the selected code, its callers, and existing changes. Identify the behavior that must remain stable, including errors and public interfaces.
- Look first for redundant branches, unnecessary indirection, duplicated logic, unused flexibility, and existing standard or project equivalents.
- Choose changes that improve readability or remove a concrete maintenance burden. Fewer lines alone do not justify denser or less explicit code.
- Preserve public interfaces and observable behavior unless the user authorizes changes. Keep unrelated cleanup and new features outside the diff.
- Run existing relevant checks before and after when practical. Add focused coverage only when needed to protect a material behavior gap.

Finish with the simplification and verification result. If no useful simplification exists, explain briefly rather than manufacturing a diff. Stop when the selected scope is simpler and its behavior is verified to the available extent.
