# Rick & Morty Location Explorer 🛸

A Flutter application for browsing Rick and Morty locations, built with clean architecture, BLoC state management, and local caching.

---

## 📱 Screenshots

> Run the app and take a screenshot to place here.  
> For desktop, resize the window to ≥900 px wide — the layout switches to a two-column sidebar view automatically.

---

## 🚀 Setup Instructions

### Prerequisites

| Tool | Version |
|------|---------|
| Flutter SDK | ≥ 3.10.0 |
| Dart SDK | ≥ 3.0.0 |
| Xcode (iOS/macOS) | ≥ 14 |
| Android Studio / NDK | Latest stable |

### Steps

```bash
# 1. Clone the repository
git clone <repo-url>
cd rick_and_morty

# 2. Install dependencies
flutter pub get

# 3. Run on your target platform
flutter run                          # default device
flutter run -d macos                 # macOS desktop
flutter run -d windows               # Windows desktop
flutter run -d chrome                # Web

# 4. Run tests
flutter test
```

No environment variables or API keys are required — the Rick and Morty API is public.

---

## 🏗️ Architecture Decisions

### Clean Architecture (3 layers)

```
lib/
├── core/           # Framework-agnostic utilities, constants, error types
├── data/           # API client, local cache, repository implementations
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/         # Entities, abstract repository contract, use cases
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/   # BLoC, pages, widgets
    ├── bloc/
    ├── pages/
    └── widgets/
```

**Why Clean Architecture?**  
It keeps business logic (domain) completely independent of Flutter, Dio, and SharedPreferences. Each layer can be tested and swapped in isolation. For a take-home at this scope it also demonstrates good engineering habits clearly.

### State Management — flutter_bloc

**Why BLoC over Riverpod/Provider/GetX?**

- Explicit event→state transitions make every state change traceable and testable without any mocking of the widget tree.
- `bloc_test` provides a clean `blocTest<>` DSL that reads like a spec.
- BLoC enforces the separation between UI (events) and logic (bloc) by design, not by convention.
- The stream-based model integrates naturally with paginated, async data flows.

Two BLoCs are used:

| BLoC | Responsibility |
|------|---------------|
| `LocationListBloc` | Pagination, search, type filter, pull-to-refresh, last-updated timestamp |
| `LocationDetailBloc` | Single location fetch + concurrent resident loading |

### Caching Strategy — Cache-First with Background Refresh

1. On every `getLocations` call the repository **checks the local cache first**.
2. If valid (< 1 hour old), it returns cached data immediately and fires a silent background network request to refresh it.
3. If stale or absent, it fetches from the network, stores the result, and returns it.

This means the app is **always responsive** on relaunch, even with no network.

Cache keys are namespaced by `page + name + type` so filtered results are also cached independently.

### Dependency Injection

Dependencies are composed manually in `main.dart` (constructor injection). No service locator (GetIt) is used — the dependency graph is shallow enough that manual composition is cleaner and more transparent.

### Adaptive Layout

A single breakpoint (`AppConstants.desktopBreakpoint = 900 px`) switches between:

- **Mobile** — vertical list with a search bar above it.
- **Desktop/Tablet** — fixed 300 px sidebar for search/filter + scrollable list on the right, constrained to 1200 px max-width for readability.

---

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_bloc` | State management |
| `equatable` | Value equality for states/entities |
| `dio` | HTTP client with interceptors & typed errors |
| `shared_preferences` | Lightweight key-value cache |
| `cached_network_image` | Disk-cached image loading |
| `shimmer` | Skeleton loading UI |
| `google_fonts` | Exo typeface (sci-fi aesthetic) |
| `bloc_test` | BLoC unit test DSL |
| `mocktail` | Type-safe mocking |

---

## 🧪 Testing

```bash
flutter test                         # all tests
flutter test test/unit/              # unit tests only
flutter test test/widget/            # widget tests only
```

**Unit tests** (`test/unit/location_list_bloc_test.dart`) cover:
- Initial state
- Successful fetch → success state
- Network failure → failure state with message
- Empty results → empty state
- `hasReachedMax` guard (no extra page loads)
- Filter change → list reset + reload

**Widget test** (`test/widget/location_card_test.dart`) covers:
- Name, type, dimension are rendered
- `onTap` callback fires
- Empty type falls back to "Unknown"

---

## ⚠️ Assumptions

1. The Rick and Morty API is public and requires no authentication.
2. "First 6 residents" are loaded concurrently via `Future.wait` — the API has no batch character endpoint.
3. Cache expiry is set to **1 hour**; this is configurable via `AppConstants.cacheExpiry`.
4. Type filter chips are populated from a curated list of known types; the API has no `/location/types` endpoint.
5. The detail page re-fetches the full location object from the network to ensure all fields (not just those on the list item) are shown.
6. Desktop support targets macOS and Windows; Linux is untested but should work.

