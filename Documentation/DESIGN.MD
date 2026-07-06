# iOS App UI/UX Design System & Coding Guidelines
**Style Theme:** Apple Minimalist (Native Premium)  
**Target Platform:** iOS (SwiftUI preferred)  
**App Goal:** Multicategory Shopping List & Tracker (Groceries, Home, Auto, Kids, Travel, etc.)

---

## 1. General Philosophy
- **Content over Chrome:** The UI must be invisible. No heavy borders, no dark card backgrounds in Light Mode, no flashy gradients. Focus purely on typography, whitespace, and clear checkmarks.
- **Native iOS Feel:** The app must look like it was built by Apple. It should feel like a sibling to the native Apple Reminders or Notes app.
- **One-Handed Usability:** All key interactive triggers (adding items, searching, ticking checkboxes) must be easily reachable within the bottom 60% of the screen (the thumb zone).

---

## 2. Color Palette & Semantic Tokens
Implement these precise HEX codes (and support system-wide Light/Dark mode transitions):

### Light Mode:
- `background`: `#FFFFFF` (Pure white for main screen and list container)
- `secondaryBackground`: `#F2F2F7` (Standard iOS light gray for grouped table styles / background behind cards)
- `surface`: `#FFFFFF` (Card or list row background)
- `textPrimary`: `#1C1C1E` (Nearly black for high contrast readability)
- `textSecondary`: `#8E8E93` (Muted gray for subtitles, timestamps, and empty states)
- `accent`: `#007AFF` (Apple System Blue — used for primary actions, active states, and checkmark fills)
- `danger`: `#FF3B30` (System Red — for delete actions and destructive swipes)
- `divider`: `#C6C6C8` (Super thin light gray for separating list rows)

### Dark Mode (Automatic Adaptation):
- `background`: `#000000` (Pure black to save OLED battery)
- `secondaryBackground`: `#1C1C1E` (Dark gray background)
- `surface`: `#1C1C1E` (Slightly lighter surface for list rows)
- `textPrimary`: `#FFFFFF` (Pure white)
- `textSecondary`: `#8E8E93` (System gray)
- `accent`: `#0A84FF` (Apple System Dark Blue)
- `danger`: `#FF453A` (System Dark Red)
- `divider`: `#38383A` (Dark gray separator)

---

## 3. Typography & Hierarchy
Use iOS system font (SF Pro) with default tracking and leading.

- **Main Navigation Header:** `Large Title` -> `SF Pro Display, 34pt, Bold` (Collapses to standard 17pt Semi-Bold inline navigation title on scroll).
- **Section/Category Headers:** `Headline` -> `SF Pro Text, 20pt, Semi-Bold`.
- **List Item Title:** `Body` -> `SF Pro Text, 17pt, Regular` (When checked: changes to `17pt, Regular` with strikethrough, opacity drops to `35%`).
- **Metadata / Category Tag / Subtext:** `Caption 1` -> `SF Pro Text, 12pt, Medium`.

---

## 4. UI Layout & Component Specifications

### A. Main Shopping List Screen (Structure)
1. **Navigation Bar:** Large native title "My Lists" (or "My Cart"). To the right: Profile button or settings gear (minimalist outline).
2. **Search Bar:** Pinned right below the header. Style: Rounded corner text field (`cornerRadius: 10`), background `#767680` with 12% opacity. Placeholder: "Search items...".
3. **List Container:** Standard Apple Grouped style. Each group represents a category (e.g., "🥕 Groceries", "🚗 Auto", "🏠 Home").
   - Category icons must strictly use **SF Symbols** (e.g., `cart.fill`, `car.fill`, `house.fill`, `gift.fill`).

### B. List Row Component (The Shopping Item)
- **Dimensions:** Fixed row height of `44pt` or `48pt` to comply with human interface touch target guidelines.
- **Left Element (Checkbox):**
  - A circle with a diameter of `24pt`.
  - **Unchecked State:** Thin outline `border: 1.5pt` with color `textSecondary` (`#8E8E93`). Inside is empty/transparent.
  - **Checked State:** Smoothly animates to fill completely with `accent` color (`#007AFF`) and displays a white native checkmark (`checkmark` SF Symbol) inside.
  - **Tap Target:** Invisible hit box around the checkbox must be at least `44x44pt` to prevent miss-clicks.
- **Center Element (Item Name & Details):**
  - Item title aligned left. 
  - (Optional) Tiny subtitle underneath with quantity or note (e.g., "2 packs", "organic only").
- **Right Element:**
  - A subtle category tag or drag-indicator handler (three horizontal lines, SF Symbol `line.3.horizontal` with `#C6C6C8` color).

### C. Category Badges (Pills)
- Height: `20pt`.
- Corner Radius: `10pt` (Capsule shape).
- Background: Very subtle pastel tint of the category color with 10% opacity (e.g., Light Green for Groceries, Light Orange for Auto).
- Text: Bold, `10pt`, matching the category color with 100% opacity.

---

## 5. Micro-Interactions, Animations & Gestures

- **The Checkmark Tap:** When a user taps the checkbox:
  1. Trigger a subtle haptic feedback (`UINotificationFeedbackGenerator` or `.light` impact).
  2. The checkbox scale-animates (shrinks slightly to 90% and springs back to 100% on fill).
  3. The text of the item gets a horizontal line-through animation from left to right.
  4. The text color smoothly dims to `35%` opacity.
  5. The item stays in place for 1.5 seconds, then smoothly animates downwards to the "Completed" section at the bottom of the list.

- **Swipe Actions (Standard iOS):**
  - **Swipe Left (destructive):** Reveal red (`danger`) button with a trash icon. Full swipe triggers delete.
  - **Swipe Right (utility):** Reveal gray/blue button to Pin or Edit item details.

- **Adding a New Item:**
  - Pinned Floating Action Button (FAB) at the bottom right (`60x60pt` circle, blue background, white plus symbol, subtle shadow `radius: 8, y: 4`).
  - Tapping it opens a sleek, minimalist bottom sheet (iOS `detents: [.medium]`) with a pre-focused text input field so the keyboard pops up immediately.

---

## 6. Zero State (Empty Screen)
When there are no items in the list:
- Background remains pure white.
- In the exact vertical and horizontal center, show a clean, native-looking vector outline illustration of a shopping cart or notebook (color: `secondaryBackground`).
- Underneath, show a centered title "No Items Yet" (`17pt, Semi-Bold`) and subtitle "Tap the + button to add your first grocery or household item." (`14pt, Regular`, `#8E8E93`).

---

## 7. SwiftUI Code Implementation Principles (For AI Developers)
When generating SwiftUI code for this app, strictly use:
- `NavigationStack` and `.navigationTitle()` with large display mode.
- `List` with `.listStyle(.grouped)` or `.listStyle(.insetGrouped)`.
- Native `.swipeActions(edge: .trailing)` for deletion.
- Standard `.animation(.spring(response: 0.3, dampingFraction: 0.7), value: ...)` for checked/unchecked transitions.
- Native `Spacer()` and `HStack`/`VStack` with precise `spacing: 8` or `spacing: 12` to maintain the 8pt grid.
