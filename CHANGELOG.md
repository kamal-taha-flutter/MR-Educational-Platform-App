# Changelog

## 1.0.0+1 — Portfolio Demo (DEMO MODE)

This repository is a **public portfolio/demo** of an educational platform
app. It is intentionally disconnected from any real backend or company
infrastructure.

### Demo mode

- All data sources are local mocks that return fictional data
  (`lib/core/demo/`). Every demo identifier is `DEMO-` prefixed.
- Demo accounts (shown on the login screen):
  - Student: `student` / `demo1234`
  - Assistant: `assistant` / `demo1234`
- A persistent **DEMO MODE** banner is shown on every screen.
- Demo QR attendance uses an in-memory log; nothing is uploaded.
  The assistant scan screen includes a "simulate scan" button.
- The update feature can preview its UI, but the APK download always
  fails by design — the demo never downloads or installs anything.
- Demo lesson videos point at Big Buck Bunny (Blender Foundation,
  Creative Commons), not at any product content.

### Removed / sanitized for public release

- Original backend hostnames, company branding assets, screenshots,
  release workflow, and CI docs containing internal URLs.
- Firebase configuration (`google-services.json`) and the Firebase /
  Google Services Gradle plugins.
- Release keystore and `keystore.properties` (moved out of the repo;
  they were never committed, only present on disk).
- Hardcoded fallback YouTube video id.

### Renamed / re-identified

- App display name: **MR Demo**
- Android/iOS bundle id: `com.example.mrportfolio`
- Version reset to `1.0.0+1`
- Neutral graduation-cap icon, splash, and favicon.

### Preserved architecture (unchanged)

- Clean-ish layered structure: `domain` (entities, repositories
  contracts, usecases) / `data` (models, remote data sources,
  repository impls) / `presentation` (Cubit/Bloc + screens).
- Dependency injection via `get_it`.
- Dio networking layer with `ApiResponse`, `NetworkExceptions`,
  timeouts, and typed failures (`dartz`).
- Role-based routing (student vs assistant), local SQLite notes,
  native APK update flow logic, QR scanning, YouTube player with
  custom controls, secure token storage, onboarding, RTL Arabic UI.
- The Dio-based remote data source classes remain in the codebase as a
  reference implementation, but are not wired into DI.
