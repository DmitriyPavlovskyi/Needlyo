# Needlyo

Shopping list application built with SwiftUI.

## Vision

Needlyo is designed to become a smooth and enjoyable shopping list app for iPhone.

The visual system follows a minimalist, calm sage palette with one primary accent color across the app.

## Tech Stack

- SwiftUI
- Observation
- MVVM-style screen state
- In-memory data model
- Speech framework
- AVFoundation

## Current features

- Main shopping list screen
- Search by item title
- Category grouping
- Checkbox completion
- Tap row to edit item title inline
- Inline edit with save / cancel icon buttons
- Auto-scroll edited item into view
- Microphone hides while editing
- Swipe-to-delete
- Voice input for adding items
- XCTest coverage for core parser, persistence, view model, and model behavior
- Rule-based category classification
- Empty state
- Minimalist calm-sage UI palette

## Test coverage

The shared Xcode scheme now has code coverage enabled for the `Needlyo` app target.

To run tests and print the coverage report in the terminal:

```bash
cd "/Users/Dmytro_Pavlovskyi1/Desktop/IOS Projects/Shopping List/Shopping List"
bash Scripts/test-coverage.sh
```

You can override the simulator destination if needed:

```bash
DESTINATION='platform=iOS Simulator,name=iPhone 17' bash Scripts/test-coverage.sh
```

## Planned next steps

- Persistence
- Repository layer
- Add item flow
- Completed section
- Additional feature coverage as the app grows

## Status

Foundation completed

Core list experience in place

Documentation aligned with current implementation

Builds should be followed by the existing test suite and an error check before changes are considered complete.
