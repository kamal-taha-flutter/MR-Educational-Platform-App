import 'package:mr/core/demo/demo_data.dart';
import 'package:mr/core/demo/demo_mode.dart';
import '../models/lesson_detail_model.dart';
import '../models/lesson_model.dart';
import 'lessons_remote_data_source.dart';

/// DEMO MODE: local mock implementation of [LessonsRemoteDataSource].
/// Returns fictional lessons (see [DemoData]). No network calls.
class DemoLessonsDataSource implements LessonsRemoteDataSource {
  @override
  Future<List<LessonModel>> getLessons() async {
    await Future<void>.delayed(DemoMode.latency);
    return DemoData.lessonsJson.map(LessonModel.fromJson).toList();
  }

  @override
  Future<LessonDetailModel> getLessonDetail(int id) async {
    await Future<void>.delayed(DemoMode.latency);
    return LessonDetailModel.fromJson(DemoData.lessonDetailJson(id));
  }
}
