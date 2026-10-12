/// Central switch for the public portfolio demo build.
///
/// This project is an INDEPENDENT DEMO of an educational app.
/// It is intentionally NOT connected to any real backend:
/// every data source is a local mock that returns fictional data.
///
/// This local demo authentication is NOT production-grade security.
/// It exists only to demonstrate role-based routing (student vs assistant).
class DemoMode {
  DemoMode._();

  /// Master switch. The whole app runs on local mock data.
  static const bool enabled = true;

  // ---------------------------------------------------------------------
  // Demo accounts (documented on the login screen as well).
  // ---------------------------------------------------------------------
  static const String studentUsername = 'student';
  static const String assistantUsername = 'assistant';
  static const String password = 'demo1234';

  /// Fictional token persisted by the real TokenStorage flow.
  static const String demoToken = 'DEMO-TOKEN-001';

  // ---------------------------------------------------------------------
  // Demo flags
  // ---------------------------------------------------------------------

  /// When true, the demo release metadata reports a version_code higher than
  /// the installed one so the mandatory-update UI can be previewed.
  /// The demo update flow NEVER downloads or installs anything.
  static const bool forceUpdateAvailable = false;

  /// Simulated network latency for mock data sources.
  static const Duration latency = Duration(milliseconds: 450);
}
