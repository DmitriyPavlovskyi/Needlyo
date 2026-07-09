# Code Style

## General

- Keep files small and focused.
- Prefer composition over inheritance.
- Avoid force unwraps.
- Prefer immutable values by default.
- One primary responsibility per type.
- Keep user-facing strings easy to localize.

## SwiftUI

Views must not contain business logic, persistence, or platform coordination.

Large views should be decomposed into reusable components.

Prefer:

- `NavigationStack` for navigation.
- `List` for list screens.
- Native `swipeActions` for destructive row actions.
- `@State` with `@Observable` view models.
- Small helper views for repeated UI fragments.

## ViewModel

Business logic belongs in ViewModels or dedicated services, not in views.

ViewModels should:

- own screen state;
- transform data into presentation state;
- coordinate services;
- stay free of layout code;
- avoid UIKit unless there is a strong platform need.

## Services

Services should:

- contain reusable app logic;
- stay independent from views;
- be easy to inject or replace in tests;
- own platform-specific operations such as speech or audio handling.

## Models

Models should:

- stay data-oriented;
- avoid UI behavior;
- avoid direct framework coupling where possible;
- remain small enough to reason about quickly.

## Feature growth

When a feature starts to grow, extract helper types before the owning file becomes hard to read.

Prefer a small number of cohesive files over one large file with mixed responsibilities.
