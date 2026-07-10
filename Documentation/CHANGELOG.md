# Changelog

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
