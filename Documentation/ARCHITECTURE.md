# Architecture

Needlyo currently uses a simple layer-based MVVM structure built with SwiftUI and the Observation framework.

## Current flow

```
NeedlyoApp
↓
RootView
↓
ShoppingListView
↓
ShoppingListViewModel
↓
Services
↓
Models
```

## Current folders

- `App/` — app entry point and root scene setup.
- `Views/` — SwiftUI screens and reusable view components.
- `ViewModels/` — screen state, user actions, and orchestration.
- `Services/` — reusable app logic such as speech recognition, speech-to-item parsing, and item classification.
- `Models/` — value types for shopping data and speech snapshots.
- `NeedlyoTests/` — XCTest coverage for the parser, persistence, view model, and model behavior.
- `Resources/` — assets and app resources.
- `Documentation/` — project rules, roadmap, and design notes.

## Current rules

- Views render UI and forward user intent.
- Views should not contain business rules or persistence logic.
- ViewModels own screen state and coordinate services.
- Services encapsulate reusable logic and platform APIs.
- Models stay lightweight and data-oriented.
- Keep responsibilities small and easy to move into feature modules later.

## What is implemented today

- A single main shopping list screen.
- Search over item titles.
- Grouping items by category.
- Swipe-to-delete.
- Checkbox completion toggling.
- Speech recognition for item entry.
- Dedicated speech-to-item parsing that splits multi-item dictation into separate items.
- Supported voice command prefixes include `додай`, `додати`, `добав`, `добави`, and `добавь`.
- Keyword-based category classification.
- XCTest coverage for the existing parser, persistence, view model, and model behavior.
- Empty state UI.

## Planned evolution

When the app grows beyond one main screen, move toward feature-first modules and add a persistence layer with repositories.

Likely next steps:

- SwiftData or another persistence solution.
- Repository abstraction above storage.
- Feature-specific folders for future screens.
- Shared UI components when they are reused across features.
