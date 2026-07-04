# Needlyo AI Rules

Version: 1.0

This document defines the development standards, architecture,
coding conventions and engineering principles used in the Needlyo project.

Every contributor (human or AI) must follow these rules.

---

# 1. Vision

Needlyo is built as a long-term product.

Every architectural decision must prioritize:

- Maintainability
- Readability
- Scalability
- Simplicity

Short-term optimizations must never reduce long-term code quality.

---

# 2. Project Philosophy

We optimize for:

Readable code > Clever code

Simple solutions > Complex solutions

Architecture > Speed

Consistency > Personal preference

Quality > Quantity

---

# 3. Architecture

Architecture:

MVVM

SwiftUI

Observation Framework

SwiftData

Dependency Injection

Repository Pattern (when persistence becomes complex)

Feature Modules (introduced when multiple features exist)

Business logic must never exist inside SwiftUI Views.

Views display data only.

---

# 4. Folder Structure

Current project structure:

Needlyo/

App/

Resources/

Views/

ViewModels/

Documentation/

When the application grows, migrate to Feature First Architecture.

---

# 5. SwiftUI Rules

Views are declarative.

Views never own business logic.

Views never perform networking.

Views never access persistence directly.

Large Views must be decomposed into reusable Components.

Avoid nested Views deeper than 3-4 levels whenever practical.

---

# 6. ViewModel Rules

Every screen owns exactly one ViewModel unless complexity requires otherwise.

ViewModels:

contain business logic

transform models into presentation state

coordinate Services

never contain UI layout

never import UIKit

Prefer value transformations over mutable state.

---

# 7. Observation

Use Apple's Observation framework.

Prefer:

@Observable

instead of:

ObservableObject

Use:

@State

instead of:

@StateObject

whenever Observation is used.

---

# 8. Models

Models contain only data.

No UI code.

No business logic.

No networking.

Prefer immutable models.

Use struct unless reference semantics are required.

---

# 9. Services

Services contain reusable application logic.

Examples:

StorageService

AnalyticsService

SettingsService

ImportExportService

Services never know about Views.

---

# 10. Persistence

SwiftData is the default persistence layer.

Repositories abstract persistence from ViewModels.

ViewModels should never manipulate SwiftData directly.

---

# 11. Naming

Use clear English names.

Avoid abbreviations.

Bad:

VM

Obj

Tmp

Mgr

Good:

ShoppingListViewModel

ShoppingItem

ShoppingRepository

---

# 12. SOLID

Follow all SOLID principles.

Single Responsibility

Open Closed

Liskov

Interface Segregation

Dependency Inversion

---

# 13. DRY

Never duplicate business logic.

Extract reusable code.

Avoid copy-paste.

---

# 14. KISS

Always choose the simplest solution that solves the problem.

Avoid unnecessary abstractions.

---

# 15. YAGNI

Do not implement functionality before it is needed.

Avoid speculative development.

---

# 16. Composition

Prefer composition over inheritance.

Avoid deep inheritance hierarchies.

---

# 17. Error Handling

Never silently ignore errors.

Avoid force unwrap (!)

Prefer Result where appropriate.

Provide meaningful error messages.

---

# 18. Optionals

Avoid force unwrap.

Prefer:

guard let

if let

nil coalescing

---

# 19. Concurrency

Use async/await.

Avoid callbacks.

All UI updates occur on MainActor.

---

# 20. Documentation

Public APIs require documentation.

Complex algorithms require comments explaining why.

Avoid comments that describe obvious code.

Explain intent.

---

# 21. Formatting

Use Xcode default formatting.

4 spaces.

One type per file.

One primary responsibility per file.

Keep files small.

Target:

<250 lines.

Ideal:

<150 lines.

---

# 22. Functions

Prefer small functions.

Target:

<30 lines.

Avoid deeply nested conditions.

Extract helper methods.

---

# 23. File Organization

Imports

Type definition

Properties

Initialization

Public methods

Private methods

Extensions

Preview

Always keep this order.

---

# 24. Git

Commit frequently.

One logical change per commit.

Every commit must compile.

Commit messages:

feat:

fix:

refactor:

docs:

test:

chore:

---

# 25. Before Every Commit

The project must:

Build successfully

Run successfully

Contain no compiler warnings

Contain no temporary code

Contain no commented-out code

---

# 26. AI Responsibilities

Before suggesting code the AI must:

understand existing architecture

avoid duplication

respect project conventions

prefer maintainability

keep consistency

After every change AI must verify:

architecture

naming

simplicity

future scalability

---

# 27. Definition of Done

A task is finished only if:

code compiles

application launches

architecture respected

documentation updated if needed

git status clean

commit created

---

# 28. Future Direction

The project is expected to evolve toward:

Feature First Architecture

Shared Components

SwiftData

Cloud Sync

Widgets

Analytics

Shortcuts

Accessibility

Localization

Unit Tests

Snapshot Tests

---

# 29. Non-Negotiable Rules

Never sacrifice readability.

Never introduce technical debt knowingly.

Never duplicate architecture.

Never place business logic inside Views.

Never push broken builds.

Never ignore compiler warnings.

Always leave the codebase cleaner than you found it.

---

# Final Principle

Every commit should make the project
better than it was before.
