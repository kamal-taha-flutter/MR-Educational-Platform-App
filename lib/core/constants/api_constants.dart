/// API surface constants for the DEMO build.
///
/// SECURITY NOTE: this portfolio demo is intentionally disconnected from any
/// real backend. The base URL uses the reserved `example.invalid` TLD
/// (RFC 2606), which can never resolve — so even if a Dio-backed data source
/// were invoked by mistake, no request could reach any real server.
///
/// The Dio-based data sources remain in the codebase as a reference
/// implementation of the networking layer, but the app registers local DEMO
/// data sources instead (see `core/di/service_locator.dart`).
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://demo.example.invalid/api/v1';

  static const String storageBaseUrl = 'https://demo.example.invalid/storage';

  /// Converts a relative image path returned by an API (e.g.
  /// `student-profiles/x.jpg`) into a full URL, and leaves full URLs as-is.
  static String? resolveImageUrl(String? path) {
    final trimmed = path?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return '$storageBaseUrl/${trimmed.replaceFirst(RegExp(r'^/+'), '')}';
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Endpoint paths (relative to the base URL above).
  static const String login = '/auth/login';
  static const String studentProfile = '/student/profile';
  static String scanStudentByQr(String qrCodeString) =>
      '/assistant/student/scan/${Uri.encodeComponent(qrCodeString)}';
  static const String registerAttendance = '/assistant/attendance/register';
  static const String lessons = '/student/lessons';
  static const String studentReports = '/student/reports';

  // App release / update endpoints (client reads these, never publishes).
  static const String latestRelease = '/app/releases/latest';
  static const String latestReleaseDownload = '/app/releases/latest/download';
}
