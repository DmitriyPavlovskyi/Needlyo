# iOS App UI/UX Design System & Coding Guidelines

**Style Theme:** Native Apple / Minimalist  
**Target Platform:** iOS (SwiftUI)  
**Current App Goal:** Multicategory shopping list with voice entry and category grouping.

---

## 1. General philosophy

- Keep the interface simple and native.
- Prefer system controls and system typography.
- Reduce visual noise and avoid heavy custom chrome.
- Keep core actions reachable and easy to understand.

---

## 2. Current visual language

The current implementation relies mainly on:

- `NavigationStack` with a large title.
- `List` using grouped / inset grouped presentation.
- Standard iOS search UI.
- A bottom microphone control bar.
- SF Symbols for icons.
- System colors for most text and background treatment.
- Category tint colors for small accent elements.

The app does not currently use a custom design token system for all surfaces, spacing, and typography.

---

## 3. Current screen structure

### Main shopping list screen

Implemented today:

1. Large navigation title.
2. Search bar below the title.
3. Grouped list sections by category.
4. Checkbox row control for completion.
5. Swipe-to-delete action.
6. Bottom microphone bar for speech input.
7. Empty state when no visible items exist.

### Shopping item row

The row currently contains:

- A 44x44 tappable checkbox area.
- A 24pt circular checkbox.
- A small category icon badge.
- The item title.
- Strikethrough and reduced opacity when completed.

---

## 4. Current interaction rules

- Tapping the checkbox toggles completion.
- Completed items remain in the same section for now.
- Swipe left deletes an item.
- The microphone button toggles speech recognition.
- When listening, the dictated text is shown above the control.
- Search filters item titles case-insensitively.

---

## 5. Empty state

When no items match the current list or search:

- Show a centered cart icon.
- Show a short empty-state title.
- Show helper text that explains how to add items with voice input.

Keep the empty state light and readable.

---

## 6. Future direction

These ideas are still planned and should be treated as future work unless explicitly implemented:

- Add-item sheet or dedicated add flow.
- Floating action button.
- Richer completion animations.
- Haptic feedback.
- Separate completed section.
- Pin/edit swipe actions.
- Custom design tokens for colors and spacing.
- Stronger accessibility and localization polish.

---

## 7. SwiftUI implementation principles

- Use `NavigationStack` and a large title for main screens.
- Keep views declarative and lightweight.
- Use `List` and standard swipe actions where possible.
- Prefer system spacing and simple layouts.
- Keep row and section components reusable.
- Use animation only when it improves clarity.
- Avoid introducing custom UI frameworks unless they solve a real need.
