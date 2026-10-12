import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import 'package:mr/core/network/network_exceptions.dart';
import '../models/scanned_student_model.dart';
import 'scan_qr_remote_data_source.dart';

/// DEMO MODE: local mock implementation of [ScanQrRemoteDataSource].
///
/// The camera can still decode any real QR code, but the scanned string is
/// only used as a local lookup key against fictional data — nothing is ever
/// sent to a server, and attendance is recorded in an in-memory demo log.
class DemoScanQrDataSource implements ScanQrRemoteDataSource {
  /// In-memory demo attendance log (never persisted, never uploaded).
  static final List<Map<String, Object>> attendanceLog = [];

  @override
  Future<ScannedStudentModel> scanStudent(String qrCodeString) async {
    await Future<void>.delayed(DemoMode.latency);

    final code = qrCodeString.trim().toUpperCase();
    if (code.isEmpty || !code.startsWith('DEMO-')) {
      throw const ApiException(
        'كود غير معروف في الوضع التجريبي. استخدم رمز الطالب التجريبي '
        '(DEMO-QR-STUDENT-001) أو زر المحاكاة في شاشة المسح.',
      );
    }

    return ScannedStudentModel.fromJson(_scannedStudentJson);
  }

  @override
  Future<void> registerAttendance(int studentId) async {
    await Future<void>.delayed(DemoMode.latency);

    attendanceLog.add({
      'student_id': studentId,
      'student_code': DemoData.scannedStudentNumber,
      'registered_at': DateTime.now().toIso8601String(),
      'note': 'DEMO MODE — local simulated attendance, nothing was uploaded',
    });
  }

  static const Map<String, dynamic> _scannedStudentJson = {
    'student_id': DemoData.scannedStudentId,
    'full_name': DemoData.scannedStudentName,
    'student_number': DemoData.scannedStudentNumber,
    'grade': DemoData.scannedStudentGrade,
    'phone': DemoData.scannedStudentPhone,
    'profile_image': null,
    'dob': DemoData.scannedStudentDob,
    'guardian_name': DemoData.scannedGuardianName,
    'guardian_phone': DemoData.scannedGuardianPhone,
  };
}
