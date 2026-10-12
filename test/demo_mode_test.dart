import 'package:flutter_test/flutter_test.dart';
import 'package:mr/core/constants/api_constants.dart';
import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import 'package:mr/core/network/network_exceptions.dart';
import 'package:mr/features/assistant/scan_qr_code/data/datasources/demo_scan_qr_data_source.dart';
import 'package:mr/features/auth/data/datasources/demo_auth_data_source.dart';
import 'package:mr/features/auth/data/models/login_request_model.dart';
import 'package:mr/features/lessons/data/datasources/demo_lessons_data_source.dart';
import 'package:mr/features/student/data/datasources/demo_profile_data_source.dart';
import 'package:mr/features/student/data/datasources/demo_reports_data_source.dart';
import 'package:mr/features/update/data/datasources/demo_release_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DemoMode configuration', () {
    test('demo mode is enabled for the portfolio build', () {
      expect(DemoMode.enabled, isTrue);
    });

    test('base URL uses only the reserved example.invalid domain', () {
      expect(ApiConstants.baseUrl, contains('example.invalid'));
      expect(ApiConstants.storageBaseUrl, contains('example.invalid'));
      expect(ApiConstants.baseUrl, isNot(contains('ertiqaa')));
      expect(ApiConstants.baseUrl, isNot(contains('mr-edu')));
    });

    test('demo identifiers are clearly prefixed', () {
      expect(DemoData.studentCode, startsWith('DEMO-'));
      expect(DemoData.studentQrCode, startsWith('DEMO-'));
      expect(DemoData.scannedStudentNumber, startsWith('DEMO-'));
    });
  });

  group('DemoAuthDataSource', () {
    final dataSource = DemoAuthDataSource();

    test('student demo account signs in with the demo token', () async {
      final response = await dataSource.login(
        const LoginRequestModel(
          username: DemoMode.studentUsername,
          password: DemoMode.password,
        ),
      );

      expect(response.success, isTrue);
      expect(response.token, DemoMode.demoToken);
      expect(response.user.role, 'student');
      expect(response.user.username, DemoMode.studentUsername);
    });

    test('assistant demo account signs in with the assistant role', () async {
      final response = await dataSource.login(
        const LoginRequestModel(
          username: DemoMode.assistantUsername,
          password: DemoMode.password,
        ),
      );

      expect(response.success, isTrue);
      expect(response.user.role, 'assistant');
    });

    test('unknown credentials are rejected', () {
      expect(
        () => dataSource.login(
          const LoginRequestModel(username: 'hacker', password: 'wrong'),
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('correct username with wrong password is rejected', () {
      expect(
        () => dataSource.login(
          const LoginRequestModel(
            username: DemoMode.studentUsername,
            password: 'nope',
          ),
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('DemoProfileDataSource', () {
    test('returns the fictional student profile', () async {
      final profile = await DemoProfileDataSource().getProfile();

      expect(profile.name, DemoData.studentName);
      expect(profile.studentCode, DemoData.studentCode);
    });
  });

  group('DemoReportsDataSource', () {
    test('returns fictional attendance records only', () async {
      final reports = await DemoReportsDataSource().getReports();

      expect(
        reports.attendance?.total,
        DemoData.reportsJson['attendance']['total'],
      );
    });
  });

  group('DemoLessonsDataSource', () {
    final dataSource = DemoLessonsDataSource();

    test('returns fictional lessons', () async {
      final lessons = await dataSource.getLessons();

      expect(lessons.length, DemoData.lessonsJson.length);
      expect(lessons.first.title, contains('DEMO-LESSON-'));
    });

    test('lesson detail uses the public demo video and neighbors', () async {
      final detail = await dataSource.getLessonDetail(2);

      expect(detail.videoUrl, DemoData.demoVideoUrl);
      expect(detail.previousLessonId, 1);
      expect(detail.nextLessonId, 3);
    });
  });

  group('DemoScanQrDataSource', () {
    test('DEMO-QR code resolves the fictional scanned student', () async {
      final student = await DemoScanQrDataSource().scanStudent(
        DemoData.studentQrCode,
      );

      expect(student.studentNumber, DemoData.scannedStudentNumber);
    });

    test('non-demo codes are rejected', () {
      expect(
        () => DemoScanQrDataSource().scanStudent('SOME-REAL-QR'),
        throwsA(isA<ApiException>()),
      );
    });

    test('attendance is recorded only in the local in-memory log', () async {
      DemoScanQrDataSource.attendanceLog.clear();

      await DemoScanQrDataSource().registerAttendance(
        DemoData.scannedStudentId,
      );

      expect(DemoScanQrDataSource.attendanceLog, hasLength(1));
      expect(
        DemoScanQrDataSource.attendanceLog.single['student_id'],
        DemoData.scannedStudentId,
      );
    });
  });

  group('DemoReleaseDataSource', () {
    test('reports up-to-date by default (no forced update)', () async {
      final release = await DemoReleaseDataSource().getLatestRelease();

      expect(release.fileName, startsWith('DEMO-APK-'));
      expect(release.fileUrl, contains('example.com'));
      expect(release.fileUrl, isNot(contains('ertiqaa')));
    });

    test('download always fails — the demo never fetches APKs', () {
      expect(
        () => DemoReleaseDataSource().downloadReleaseApk(
          'https://example.com/DEMO-APK-not-a-real-download.apk',
          'whatever.apk',
        ),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
