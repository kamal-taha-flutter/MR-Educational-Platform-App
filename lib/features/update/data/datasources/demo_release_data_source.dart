import 'dart:io';

import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import 'package:mr/core/network/network_exceptions.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../models/release_model.dart';
import 'release_remote_data_source.dart';

/// DEMO MODE: local mock implementation of [ReleaseRemoteDataSource].
///
/// - [getLatestRelease] returns fictional release metadata. By default the
///   reported `version_code` equals the installed one (so the app proceeds
///   normally); set [DemoMode.forceUpdateAvailable] to `true` to preview the
///   mandatory-update UI.
/// - [downloadReleaseApk] ALWAYS fails with a clear message. The demo can
///   never download or install an APK.
class DemoReleaseDataSource implements ReleaseRemoteDataSource {
  @override
  Future<ReleaseModel> getLatestRelease() async {
    await Future<void>.delayed(DemoMode.latency);

    final installedVersionCode = await _installedVersionCode() ?? 1;
    final reportedVersionCode = DemoMode.forceUpdateAvailable
        ? installedVersionCode + 1
        : installedVersionCode;

    return ReleaseModel.fromJson(DemoData.releaseJson(reportedVersionCode));
  }

  @override
  Future<void> downloadReleaseApk(
    String url,
    String savePath, {
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    await Future<void>.delayed(DemoMode.latency);

    // Hard guarantee: the demo never downloads or installs APKs.
    // Delete anything that might already exist at the target path.
    try {
      final file = File(savePath);
      if (file.existsSync()) await file.delete();
    } catch (_) {
      // Ignore cleanup failures; the download is blocked either way.
    }

    throw const ApiException(
      'التنزيل والتثبيت معطّلان في نسخة العرض التجريبي (DEMO MODE).',
    );
  }

  Future<int?> _installedVersionCode() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return int.tryParse(packageInfo.buildNumber);
    } catch (_) {
      return null;
    }
  }
}
