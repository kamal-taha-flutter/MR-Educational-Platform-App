# MR Demo — Educational Platform (Portfolio Build)

A Flutter educational platform demo, prepared as a **public portfolio
build**. It showcases a complete mobile architecture (authentication,
lessons, QR attendance, reports, notes, in-app updates) using
**fictional data only**.

> **DEMO MODE** — This app is **not connected to any real backend**,
> database, Firebase project, or company infrastructure. All data is
> local and fictional. A DEMO MODE banner is shown on every screen.

## Demo accounts

| Role      | Username    | Password  |
|-----------|-------------|-----------|
| Student   | `student`   | `demo1234`|
| Assistant | `assistant` | `demo1234`|

This local "login" only demonstrates role-based routing. It is **not**
real authentication and provides no security.

## What's inside

- **Auth** — login with role-based routing (student vs assistant),
  token storage, auto-auth on app start.
- **Student** — profile, lessons list with chapters, rich lesson
  detail (video player with custom controls, "what you'll learn",
  teacher notes), locally persisted notes (SQLite), attendance &
  financial reports.
- **Assistant** — scan a student QR code and register attendance.
  The demo includes a **simulate scan** button and records attendance
  in a local in-memory log only.
- **Update flow** — version comparison, cached-APK handling, and
  installer plumbing are all real code, but the demo **never
  downloads or installs** anything (download always fails by design).
- **Onboarding**, RTL Arabic UI, responsive layouts
  (`flutter_screenutil`), Cubit/Bloc state management.

## Architecture

```
lib/
├── core/           # DI (get_it), Dio client, ApiResponse/NetworkExceptions,
│   │               # routing, secure storage, theme, shared widgets, demo data
│   ├── demo/       # DemoMode switch + all fictional demo data
│   ├── di/         # service_locator (registers DEMO data sources)
│   └── network/    # reusable Dio layer (kept as reference implementation)
└── features/
    ├── auth/         # domain / data / presentation
    ├── student/      # profile, lessons, reports
    ├── assistant/    # scan QR + attendance
    ├── lessons/      # lessons, detail, notes (sqflite)
    └── update/       # release check, download, install
```

Each feature follows a layered structure:

- `domain/` — entities, repository contracts, use cases.
- `data/` — models, remote data source interface + Dio implementation
  + demo (mock) implementation, repository implementation.
- `presentation/` — Cubit/Bloc, screens, widgets.

**Demo wiring:** `service_locator.dart` registers the local
`Demo*DataSource` classes. The Dio-based implementations remain in the
codebase as a reference, and the base URL uses the reserved
`https://demo.example.invalid` domain which can never resolve.

## Demo guarantees

- No real hostnames, API keys, tokens, or personal data anywhere in
  the repository.
- No Firebase (`google-services.json` removed, plugins removed).
- All demo identifiers are `DEMO-` prefixed.
- Demo videos use Big Buck Bunny (Blender Foundation, Creative
  Commons) — not any product content.
- Update flow can preview its UI (`DemoMode.forceUpdateAvailable`)
  but never downloads or installs an APK.

## Getting started

```bash
flutter pub get
flutter run
```

Checks:

```bash
flutter analyze
flutter test
```

CI (GitHub Actions) runs the same checks plus a guard that fails if any
real-backend hostname or API key pattern reappears in source.

## Notes for reviewers

- `flutter_secure_storage`, `sqflite`, `package_info_plus`,
  `path_provider`, `open_filex` are wired with real platform channels.
- The QR scanner uses a real camera plugin; any scanned code is only
  used as a local lookup key.
- See `CHANGELOG.md` for the full list of what was sanitized for this
  public build.
