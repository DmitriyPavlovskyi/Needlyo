# Changelog

## 0.5

### Added

- XCTest coverage for the core shopping list behavior.
- A shared test target and scheme so the test suite can run from Xcode.

### Changed

- Documentation now requires running the existing test suite and checking for errors whenever a build is performed.
- New tests are only written when explicitly requested.

### Notes

- The core parser, persistence service, view model operations, and model serialization are now covered by tests.

## 0.4

### Changed

- Improved voice dictation parsing so multiple items spoken in one sentence are split into separate shopping items more reliably.
- Introduced a dedicated speech-to-item parsing service to keep parsing logic isolated from the ViewModel.
- Expanded supported voice command prefixes to include `додай`, `додати`, `добав`, `добави`, and `добавь`.

### Notes

- The app now handles multi-item dictation better when users say a list in one sentence.

## 0.3

### Changed

- Aligned documentation with the current SwiftUI implementation.
- Clarified which UX and architecture ideas are implemented today versus planned for later.
- Added documentation sync guidance to the AI rules.

### Notes

- The app still uses an in-memory shopping list model and a single main feature screen.

## 0.2

### Changed

- Switched to Feature First Architecture

### Added

- Project documentation
- Development standards
