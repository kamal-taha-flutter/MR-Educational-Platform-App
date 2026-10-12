import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import '../models/reports_model.dart';
import 'reports_remote_data_source.dart';

/// DEMO MODE: local mock implementation of [ReportsRemoteDataSource].
/// Returns fictional attendance/financial reports (see [DemoData]).
/// No network calls, no real student or financial records.
class DemoReportsDataSource implements ReportsRemoteDataSource {
  @override
  Future<ReportsModel> getReports() async {
    await Future<void>.delayed(DemoMode.latency);
    return ReportsModel.fromJson(DemoData.reportsJson);
  }
}
