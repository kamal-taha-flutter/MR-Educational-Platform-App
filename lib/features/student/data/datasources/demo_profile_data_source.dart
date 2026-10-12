import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import '../models/student_profile_model.dart';
import 'profile_remote_data_source.dart';

/// DEMO MODE: local mock implementation of [ProfileRemoteDataSource].
/// Returns a fictional student profile (see [DemoData]). No network calls.
class DemoProfileDataSource implements ProfileRemoteDataSource {
  @override
  Future<StudentProfileModel> getProfile() async {
    await Future<void>.delayed(DemoMode.latency);
    return StudentProfileModel.fromJson(_profileJson);
  }

  static const Map<String, dynamic> _profileJson = {
    'id': DemoData.studentId,
    'name': DemoData.studentName,
    'username': DemoData.studentUsername,
    'phone': DemoData.studentPhone,
    'email': DemoData.studentEmail,
    'qr_code_string': DemoData.studentQrCode,
    'student_code': DemoData.studentCode,
    'grade': DemoData.studentGrade,
    'profile_image': null,
    'dob': DemoData.studentDob,
    'guardian_name': DemoData.guardianName,
    'guardian_phone': DemoData.guardianPhone,
  };
}
