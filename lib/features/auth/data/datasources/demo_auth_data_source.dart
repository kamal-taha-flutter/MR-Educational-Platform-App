import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import 'package:mr/core/network/network_exceptions.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import 'auth_remote_data_source.dart';

/// DEMO MODE: local mock implementation of [AuthRemoteDataSource].
///
/// No network request is made. The two documented demo accounts below are
/// the ONLY accepted credentials; everything else fails with a friendly
/// message. This is NOT real authentication and provides NO security — it
/// only demonstrates role-based routing (student vs assistant).
class DemoAuthDataSource implements AuthRemoteDataSource {
  Future<void> _simulateLatency() => Future<void>.delayed(DemoMode.latency);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    await _simulateLatency();

    final username = request.username.trim();
    final password = request.password;

    final isStudent = username == DemoMode.studentUsername;
    final isAssistant = username == DemoMode.assistantUsername;

    if ((isStudent || isAssistant) && password == DemoMode.password) {
      return LoginResponseModel.fromJson(_successResponse(username, isStudent));
    }

    // Thrown (instead of a success:false payload) because the repository
    // converts exceptions into a user-facing Failure via NetworkExceptions.
    throw const ApiException(
      'هذا العرض التجريبي يقبل فقط الحسابات الموثّقة في شاشة تسجيل الدخول.',
    );
  }

  Map<String, dynamic> _successResponse(String username, bool isStudent) {
    return {
      'success': true,
      'message': 'تم تسجيل الدخول بنجاح (عرض تجريبي)',
      'data': {
        'token': DemoMode.demoToken,
        'user': {
          'id': isStudent ? DemoData.studentId : DemoData.scannedStudentId,
          'name': isStudent ? DemoData.studentName : 'مساعد تجريبي',
          'username': username,
          'role': isStudent ? 'student' : 'assistant',
          'email': isStudent
              ? DemoData.studentEmail
              : 'demo.assistant@example.com',
        },
      },
    };
  }
}
