/// FICTIONAL DEMO DATA — nothing here comes from a real user, student,
/// staff member, course, report, or backend response.
///
/// All identifiers use the `DEMO-` prefix on purpose so it is obvious at a
/// glance that the data is invented (e.g. `DEMO-STUDENT-001`).
class DemoData {
  DemoData._();

  // ---------------------------------------------------------------------
  // Student profile
  // ---------------------------------------------------------------------
  static const int studentId = 1;
  static const String studentName = 'طالب تجريبي';
  static const String studentUsername = 'demo.student';
  static const String studentCode = 'DEMO-STUDENT-001';
  static const String studentGrade = 'الصف الأول الثانوي - فصل تجريبي';
  static const String studentPhone = '0000-000-0000';
  static const String studentEmail = 'demo.student@example.com';
  static const String studentDob = '2008-01-01';
  static const String studentQrCode = 'DEMO-QR-STUDENT-001';
  static const String guardianName = 'ولي أمر تجريبي';
  static const String guardianPhone = '0000-000-0001';

  // ---------------------------------------------------------------------
  // Scanned student (assistant QR attendance flow)
  // ---------------------------------------------------------------------
  static const int scannedStudentId = 2;
  static const String scannedStudentName = 'طالب مسح تجريبي';
  static const String scannedStudentNumber = 'DEMO-STUDENT-002';
  static const String scannedStudentGrade = 'الصف الثاني الثانوي - فصل تجريبي';
  static const String scannedStudentPhone = '0000-000-0002';
  static const String scannedStudentDob = '2007-01-01';
  static const String scannedGuardianName = 'ولي أمر تجريبي 2';
  static const String scannedGuardianPhone = '000-000-0003';

  // ---------------------------------------------------------------------
  // Lessons
  //
  // `videoUrl` points to Big Buck Bunny (Blender Foundation), a well-known
  // Creative Commons public demo film — it is NOT educational product
  // content. `thumbnailUrl` is intentionally empty so the UI falls back to
  // its local placeholder instead of loading any remote/company image.
  // ---------------------------------------------------------------------
  static const String demoVideoUrl = 'https://youtu.be/aqz-KE-bpKQ';

  static const List<Map<String, dynamic>> lessonsJson = [
    {
      'id': 1,
      'chapter_name': 'الفصل التجريبي الأول',
      'title': 'DEMO-LESSON-001: المقدمة والتعريف',
      'duration_minutes': 12,
      'thumbnail_url': '',
    },
    {
      'id': 2,
      'chapter_name': 'الفصل التجريبي الأول',
      'title': 'DEMO-LESSON-002: الشرح والتمارين',
      'duration_minutes': 18,
      'thumbnail_url': '',
    },
    {
      'id': 3,
      'chapter_name': 'الفصل التجريبي الثاني',
      'title': 'DEMO-LESSON-003: حل المسائل',
      'duration_minutes': 15,
      'thumbnail_url': '',
    },
  ];

  static Map<String, dynamic> lessonDetailJson(int id) {
    final index = lessonsJson.indexWhere((lesson) => lesson['id'] == id);
    final summary = index == -1 ? lessonsJson.first : lessonsJson[index];
    final lessonId = summary['id'] as int;

    return {
      'id': lessonId,
      'chapter_name': summary['chapter_name'],
      'title': summary['title'],
      'duration_minutes': summary['duration_minutes'],
      'video_url': demoVideoUrl,
      'thumbnail_url': '',
      'about_lesson':
          'هذا نص توضيحي تخيّلي بالكامل، مكتوب لعرض واجهة تفاصيل الدرس في '
          'نسخة العرض التالية. لا يمثّل محتوى دورة أو منهجًا حقيقيًا بأي شكل.',
      'what_you_will_learn': [
        'التعرّف على بنية شاشة تفاصيل الدرس',
        'استخدام مشغّل الفيديو والتحكم المخصص',
        'إضافة ملاحظات محلية محفوظة في SQLite',
      ],
      'notes': 'ملاحظات المدرّس هذه نص تجريبي بالكامل.',
      'created_at': '2026-01-05T10:00:00+00:00',
      'updated_at': '2026-01-05T10:00:00+00:00',
      'previous_lesson_id': _neighborId(lessonId, -1),
      'next_lesson_id': _neighborId(lessonId, 1),
    };
  }

  static int? _neighborId(int id, int offset) {
    final target = id + offset;
    return lessonsJson.any((lesson) => lesson['id'] == target) ? target : null;
  }

  // ---------------------------------------------------------------------
  // Student reports (attendance + financials)
  // ---------------------------------------------------------------------
  static const Map<String, dynamic> reportsJson = {
    'student': {
      'id': studentId,
      'name': studentName,
      'student_code': studentCode,
      'grade': studentGrade,
      'group_name': 'مجموعة تجريبية أ',
      'profile_image': null,
    },
    'attendance': {
      'total': 6,
      'records': [
        {'id': 1, 'date': '2026-01-04'},
        {'id': 2, 'date': '2026-01-07'},
        {'id': 3, 'date': '2026-01-11'},
        {'id': 4, 'date': '2026-01-14'},
        {'id': 5, 'date': '2026-01-18'},
        {'id': 6, 'date': '2026-01-21'},
      ],
    },
    'financials': {'total': 0, 'records': []},
  };

  // ---------------------------------------------------------------------
  // App release metadata (update feature)
  // ---------------------------------------------------------------------
  static Map<String, dynamic> releaseJson(int versionCode) => {
    'id': 1,
    'version_code': versionCode,
    'version_name': '1.0.$versionCode-demo',
    'changelog':
        '* عرض تجريبي للواجهة فقط\n'
        '* لا يتصل العرض بأي خادم ولا ينزّل أي ملفات',
    'file_name': 'DEMO-APK-$versionCode.apk',
    'file_size': 1024,
    // Reserved example domain: intentionally unreachable.
    'file_url': 'https://example.com/DEMO-APK-not-a-real-download.apk',
    'published_at': '2026-01-01T00:00:00+00:00',
  };
}
