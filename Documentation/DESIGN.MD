# Needlyo Visual Design System

**Style Theme:** Minimalist, native iOS, one-accent system  
**Target Platform:** iOS (SwiftUI)  
**Current App Goal:** A calm, readable shopping list app with voice input and category grouping.

This document is the source of truth for the app's visual language. Future UI work must follow these rules unless this file is updated first.

---

## 1. Design intent

Needlyo should feel:

- calm
- practical
- lightweight
- native to iOS
- easy to scan quickly while shopping

The content is the product. The interface must stay quiet and get out of the way.

### What we take from the provided references

The shared examples all point to the same direction:

- list-first layout
- strong hierarchy with simple rows
- one dominant accent color instead of many competing colors
- thin separators and generous whitespace
- compact but readable item rows
- minimal iconography
- clear checked / unchecked states
- low visual noise

### What we intentionally do not take

- colorful category coding
- decorative gradients
- heavy shadows
- custom fonts
- overly stylized chrome
- multiple unrelated accent colors on one screen

---

## 2. Locked visual principles

These rules are mandatory for the app UI:

1. Use a neutral base with one primary accent color.
2. Keep the same color family across the whole app.
3. Do not assign different colors to different shopping categories.
4. Use color only when it carries meaning.
5. Prefer standard iOS layout patterns over custom visuals.
6. Keep every screen simple enough to understand in one glance.

### Approved color model

The app should use:

- **Neutral surfaces** for background, cards, and rows.
- **One primary accent color** for interactive highlights, selection, and primary actions.
- **Standard destructive red** only for destructive actions when the platform convention requires it.
- **System text colors** for hierarchy and contrast.

The approved palette is the calm sage direction from the icon study.

### Official palette

These hex values are the source palette for the whole app:

- Background: `#FAFAF5`
- Surface: `#FFFFFF`
- Surface subtle: `#F2F5EE`
- Primary accent: `#7FB76F`
- Primary accent strong: `#648E57`
- Primary accent soft: `#D8E7CD`
- Accent dark: `#194618`
- Divider / border: `#E3E7DD`

### Semantic tokens

Code should use semantic tokens, not raw color values in screen files.

Recommended token names:

- `app.background`
- `app.surface`
- `app.surfaceSubtle`
- `app.border`
- `app.primary`
- `app.primaryStrong`
- `app.primarySoft`
- `app.primaryText`
- `app.textPrimary`
- `app.textSecondary`
- `app.destructive`

Token usage rules:

- `app.background` for screen backgrounds
- `app.surface` for cards and elevated surfaces
- `app.surfaceSubtle` for secondary grouping and inactive areas
- `app.border` for separators and strokes
- `app.primary` for active states, main controls, and selection
- `app.primaryStrong` for pressed or emphasized accent states
- `app.primarySoft` for low-emphasis accent backgrounds and badges
- `app.primaryText` for text or icons that sit on the accent color
- `app.textPrimary` and `app.textSecondary` for all body content
- `app.destructive` only for delete and other destructive actions

### Scaling rule

If the palette changes later, only the source palette and token mapping should change. Screen logic, spacing, and component structure should stay the same.

If a new color is introduced for a specific view, it must first be added as a semantic token here, not hardcoded directly in code.

---

## 3. Typography

Use the system font only.

Rules:

- Large title for the primary list screen.
- Body text for shopping items.
- Footnote / caption for secondary metadata like totals or helper text.
- Use semibold sparingly for emphasis.
- Avoid custom typefaces.
- Avoid mixing too many font weights in one screen.

Text hierarchy should come from size, weight, and spacing — not from color overload.

---

## 4. Spacing and layout

Use an 8-point spacing system.

Guidelines:

- keep rows compact but comfortable
- leave enough whitespace around primary content
- align content consistently from screen to screen
- prefer simple vertical stacks over dense nested layouts
- use thin dividers instead of heavy borders when separation is needed

Recommended feel:

- content-first
- airy but efficient
- no crowded cards
- no unnecessary empty chrome

Corner radius should stay subtle and consistent. Do not introduce random radii across the app.

---

## 5. Core UI surfaces

### App shell

- Use `NavigationStack` for the main experience.
- Use standard iOS navigation patterns.
- Keep toolbar content minimal.
- Avoid custom headers unless they solve a real usability problem.

### List screens

- Use `List` as the main container for item-based screens.
- Keep grouping simple and readable.
- Use section headers only when they help scanning.
- Avoid over-designed section chrome.

### Rows

Each shopping row should stay minimal:

- leading checkbox or completion indicator
- item title
- optional small secondary value aligned consistently
- subtle completed state styling

Completed items should be communicated with:

- reduced emphasis
- strikethrough when appropriate
- consistent opacity changes

Do not use bright colors to mark completion.

### Search

- Use the native iOS search UI.
- Do not create a custom search bar unless required later.

### Bottom controls

- Keep bottom controls minimal and functional.
- Use the primary accent only for the main voice / add interaction.
- Any supporting labels or summaries should stay neutral.

---

## 6. Interaction rules

- Tapping a checkbox toggles completion.
- Tapping the item body opens inline edit mode for the title.
- Inline edit mode uses a text field with icon-only save / cancel controls.
- The microphone area must hide while editing is active.
- When editing starts, the list should keep the edited row visible and scrolled above the keyboard.
- Swipe actions should stay standard iOS gestures.
- Destructive actions should remain clearly destructive.
- Search filters item titles case-insensitively.
- Voice input should be calm and unobtrusive.
- Animations should be subtle and informative, not decorative.

Feedback rules:

- use state changes before ornamental animation
- keep haptics optional and restrained
- never make a simple action feel visually noisy

---

## 7. Empty states

Empty states should be minimal and useful.

When there are no visible items:

- show one clear icon
- show one short title
- show one short helper line
- avoid extra decoration
- keep the layout centered and readable

The empty state should match the rest of the app: quiet, neutral, and easy to understand.

---

## 8. Component rules

### Buttons

- Use one primary button style for the main action.
- Use secondary / plain styles for supporting actions.
- Do not create multiple competing button colors.

### Icons

- Use SF Symbols.
- Prefer monochrome icons.
- Use accent color only where interaction state requires it.
- Do not use decorative icon colors.

### Chips, badges, and labels

- Use them sparingly.
- They must not introduce a new color language.
- If a badge is needed, keep it neutral or use the primary accent tone.

### Cards

- Use cards only when grouping genuinely improves readability.
- If a list row can do the job, prefer the row.
- Do not wrap everything in cards by default.

---

## 9. Anti-patterns

The following are not allowed unless this document is updated first:

- category-specific color palettes
- rainbow-style accents
- multiple unrelated saturated colors on one screen
- heavy shadows
- large decorative illustrations in core flows
- custom typography systems
- loud gradients
- overuse of rounded containers
- complex visual chrome that distracts from the list

If a new UI idea introduces a new color or surface treatment, document the reason before implementing it.

---

## 10. Current screen structure

### Main shopping list screen

The primary screen should follow this structure:

1. Large title.
2. Optional lightweight search.
3. Simple grouped list sections.
4. Minimal item rows.
5. Standard swipe actions.
6. A restrained bottom interaction area when needed.
7. Clear empty state when nothing matches.

### Shopping item row

The row should contain only what it needs:

- tappable completion area for done / undone
- tappable body area for inline editing
- item title
- optional secondary info like quantity or price
- subtle completion styling
- icon-only save / cancel controls while editing

If an element does not help the user shop faster, remove it.

---

## 11. Future direction

These items are still future work unless explicitly implemented:

- add-item sheet or dedicated add flow
- richer completion animations
- haptic feedback polish
- separate completed section
- optional edit affordance refinements, if we later want a dedicated edit button instead of tap-to-edit
- stronger accessibility and localization polish
- additional semantic tokens only if a new UI pattern genuinely needs them

Future additions must stay inside the same visual system described above.

---

## 12. SwiftUI implementation principles

- Use `NavigationStack` and a large title for main screens.
- Keep views declarative and lightweight.
- Use `List` and standard swipe actions where possible.
- Prefer system spacing and simple layouts.
- Keep row and section components reusable.
- Use animation only when it improves clarity.
- Avoid introducing custom UI frameworks unless they solve a real need.
- Centralize any repeated visual constants before the UI starts to drift.

### Implementation rule

If code needs a new visual token, ask first:

1. Is it neutral?
2. Can it reuse the existing accent color?
3. Does it add real clarity?
4. Does it fit the same color family?

If the answer is no, do not add it.
