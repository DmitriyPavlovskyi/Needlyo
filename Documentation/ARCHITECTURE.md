# Architecture

Needlyo follows Feature First Architecture.

```
Feature

↓

View

↓

ViewModel

↓

Services

↓

Persistence
```

Rules

- Views contain UI only.
- ViewModels contain business logic.
- Models contain data only.
- Services contain reusable functionality.
- Shared contains reusable code across features.
