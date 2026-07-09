# Needlyo AI Rules

Version: 1.1

This document defines the development standards, architecture, coding conventions, and engineering principles used in the Needlyo project.

Every contributor (human or AI) must follow these rules.

---

# 1. Vision

Needlyo is a long-term product. Every architectural decision must prioritize:

- Maintainability
- Readability
- Simplicity
- Scalability
- Consistency

Short-term convenience must not create long-term maintenance cost.

---

# 2. Project philosophy

We optimize for:

- Readable code over clever code
- Simple solutions over complex solutions
- Consistency over personal preference
- Quality over quantity
- Architecture over speed when the two conflict

If a solution is technically correct but hard to understand, prefer the clearer option.

---

# 3. Current architecture

Needlyo currently uses:

- SwiftUI
- Observation framework
- MVVM-style screen state
- Layer-based folder structure
- Services for reusable logic
- Data-only model types

Current flow:

`NeedlyoApp -> RootView -> ShoppingListView -> ShoppingListViewModel -> Services -> Models`

Rules:

- Views render UI and forward user intent.
- ViewModels own screen state and orchestration.
- Services encapsulate reusable logic and platform APIs.
- Models stay lightweight and data-oriented.
- Business logic must not live inside Views.

---

# 4. Folder structure

Current project structure:

- `App/`
- `Views/`
- `ViewModels/`
- `Services/`
- `Models/`
- `Resources/`
- `Documentation/`

Guidelines:

- Keep the current structure simple while the app has one primary feature.
- Move to feature-first modules when multiple screens or workflows create real complexity.
- Shared components should only be introduced when reuse is proven.

---

# 5. SwiftUI rules

- Views are declarative.
- Views must not contain business logic.
- Views must not access persistence directly.
- Views must not coordinate platform APIs directly when a service can do it.
- Large views should be decomposed into reusable components.
- Keep nested view hierarchies shallow when practical.
- Prefer native SwiftUI controls before custom UI.
- All visual decisions must follow `Documentation/DESIGN.MD`.
- Do not introduce new colors, tints, or surface treatments unless the design document is updated first.
- The app should stay within one neutral visual system plus one primary accent color.
- Use semantic design tokens for all colors.
- Do not hardcode hex values, named colors, or category-specific tints inside Views.
- If the palette changes, update the centralized token mapping once instead of changing each screen.
- Keep color usage semantic: background, surface, border, primary, soft accent, text, destructive.

Current implementation note:

- `ShoppingListView` owns the main screen composition.
- `ShoppingItemRow` is a reusable row component.
- The app currently uses `NavigationStack`, `List`, `searchable`, and `swipeActions`.

---

# 6. ViewModel rules

- Each screen should have one main ViewModel unless complexity requires more.
- ViewModels contain business logic and screen state.
- ViewModels coordinate services.
- ViewModels transform raw data into presentation state.
- ViewModels must not contain layout code.
- ViewModels must not import UIKit unless there is a strong platform reason.
- Prefer value transformations over excessive mutable state.

Current implementation note:

- `ShoppingListViewModel` currently handles search, grouping, completion toggling, speech recognition flow, and voice parsing.
- If a ViewModel starts to collect too many responsibilities, extract a helper service or parser.

---

# 7. Observation

Use Apple's Observation framework.

Prefer:

- `@Observable`
- `@State`

Avoid:

- `ObservableObject` unless you specifically need it
- `@StateObject` when Observation already solves the problem

---

# 8. Models

- Models contain data only.
- Models should not contain UI layout.
- Models should not contain platform coordination.
- Models should not contain networking.
- Prefer `struct` unless reference semantics are required.
- Keep models small and explicit.

If a type starts to mix data and presentation metadata, separate the responsibilities before the model becomes hard to reuse.

---

# 9. Services

Services contain reusable application logic.

Examples in this project:

- `SpeechRecognitionService`
- `ShoppingItemClassificationService`

Service rules:

- Services must not know about Views.
- Services should be easy to test in isolation.
- Services should own platform-specific work such as speech, audio, or classification rules.
- Prefer dependency injection when a service can vary in tests or future implementations.

---

# 10. Persistence

- Persistence is not fully implemented yet.
- Do not pretend it exists in documentation or code comments.
- When persistence is added, ViewModels should not talk directly to storage APIs if a repository can abstract the dependency.
- SwiftData is a likely future default, but it is not required today.

---

# 11. Naming

Use clear English names.

Avoid abbreviations such as:

- `VM`
- `Obj`
- `Tmp`
- `Mgr`

Prefer descriptive names such as:

- `ShoppingListViewModel`
- `ShoppingItem`
- `ShoppingRepository`

Use Ukrainian or localized user-facing text only where it is intentionally part of the product experience.

---

# 12. Error handling

- Never silently ignore errors.
- Avoid force unwraps.
- Prefer `guard let`, `if let`, and nil coalescing.
- Provide meaningful user-facing error messages.
- Prefer `Result` or `async` error propagation when it improves clarity.

---

# 13. Concurrency

- Prefer `async`/`await` over callback-heavy code when practical.
- Keep UI updates on `MainActor`.
- Keep long-running work off the main thread unless the API requires otherwise.

---

# 14. Formatting

- Use Xcode default formatting.
- Prefer four-space indentation.
- Keep one primary responsibility per file.
- Keep files small and readable.
- Aim for small functions with clear names.
- Extract helper methods instead of nesting deep conditionals.

Practical targets:

- Views: ideally under 150 lines when reasonable
- ViewModels: keep small enough to scan quickly
- Services: keep focused on one job

---

# 15. Documentation

Documentation must stay synchronized with the implementation.

Required docs sync rule:

- After every completed code change, update all affected documentation before finishing the work.
- If architecture, behavior, or UI changes, update the relevant files in `Documentation/` and `README.md` in the same iteration.
- Do not leave docs in a state that contradicts the current app.
- If a rule or design note becomes outdated, either update it or move it clearly into a future-direction section.

This is a mandatory rule.

---

# 16. Design token scaling

The visual system must remain easy to change later.

Rules:

- Keep the palette in one centralized design source.
- Keep semantic token names stable even if the underlying hex values change.
- Update the design document first when changing palette direction.
- Avoid spreading direct color values across Views, ViewModels, or services.
- If a view needs a new color behavior, define the semantic need first, then add the token centrally.

This rule exists so the app can evolve visually without large-scale refactors.

---

# 17. Git workflow

- Commit frequently.
- Keep each commit logically focused.
- Every commit should compile.
- Every commit should reflect a clean state.

Commit prefixes:

- `feat:`
- `fix:`
- `refactor:`
- `docs:`
- `test:`
- `chore:`

Before finishing work:

- build successfully
- run successfully when practical
- update docs if anything changed
- avoid temporary or commented-out code

---

# 18. Future direction

The project is expected to evolve toward:

- Persistence
- Repository pattern
- Feature-first architecture
- Shared components
- Localization
- Accessibility improvements
- Widgets
- Siri and shortcuts
- iCloud sync
- Tests

These are future goals unless they are explicitly implemented.

---

# 19. Non-negotiable rules

- Never sacrifice readability.
- Never introduce technical debt knowingly.
- Never duplicate architecture.
- Never place business logic inside Views.
- Never ignore compiler warnings.
- Never push a broken state intentionally.
- Always leave the codebase cleaner than you found it.

---

# Final principle

Every change should make Needlyo easier to understand, easier to extend, and more consistent than before.