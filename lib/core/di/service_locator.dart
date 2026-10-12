import 'package:get_it/get_it.dart';
import '../demo/demo_mode.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';
import '../storage/onboarding_storage.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/demo_auth_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auto_auth_cubit.dart';
import '../../features/auth/domain/usecases/check_auth_status.dart';
import '../../features/student/data/datasources/profile_remote_data_source.dart';
import '../../features/student/data/datasources/demo_profile_data_source.dart';
import '../../features/student/data/datasources/reports_remote_data_source.dart';
import '../../features/student/data/datasources/demo_reports_data_source.dart';
import '../../features/student/data/repositories/profile_repository_impl.dart';
import '../../features/student/data/repositories/reports_repository_impl.dart';
import '../../features/student/domain/repositories/profile_repository.dart';
import '../../features/student/domain/repositories/reports_repository.dart';
import '../../features/student/presentation/cubit/profile_cubit.dart';
import '../../features/student/presentation/cubit/reports_cubit.dart';
import '../../features/assistant/scan_qr_code/data/datasources/scan_qr_remote_data_source.dart';
import '../../features/assistant/scan_qr_code/data/datasources/demo_scan_qr_data_source.dart';
import '../../features/assistant/scan_qr_code/data/repositories/scan_qr_repository_impl.dart';
import '../../features/assistant/scan_qr_code/domain/repositories/scan_qr_repository.dart';
import '../../features/assistant/scan_qr_code/presentation/cubit/scan_qr_cubit.dart';
import '../../features/lessons/data/datasources/lessons_remote_data_source.dart';
import '../../features/lessons/data/datasources/demo_lessons_data_source.dart';
import '../../features/lessons/data/repositories/lessons_repository_impl.dart';
import '../../features/lessons/domain/repositories/lessons_repository.dart';
import '../../features/lessons/presentation/cubit/lessons_cubit.dart';
import '../../features/lessons/presentation/cubit/lesson_detail_cubit.dart';
import '../../features/lessons/presentation/cubit/lesson_notes_cubit.dart';
import '../../features/lessons/data/datasources/notes_database.dart';
import '../../features/lessons/data/repositories/lesson_notes_repository_impl.dart';
import '../../features/lessons/domain/repositories/lesson_notes_repository.dart';
import '../../features/update/data/datasources/release_remote_data_source.dart';
import '../../features/update/data/datasources/demo_release_data_source.dart';
import '../../features/update/data/datasources/apk_installer.dart';
import '../../features/update/data/repositories/update_repository_impl.dart';
import '../../features/update/domain/repositories/update_repository.dart';
import '../../features/update/domain/usecases/download_release_apk.dart';
import '../../features/update/domain/usecases/get_latest_release.dart';
import '../../features/update/presentation/cubit/update_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<OnboardingStorage>(() => OnboardingStorage());

  // -------------------------------------------------------------------------
  // DEMO MODE wiring.
  //
  // The repository + domain + presentation layers are the real production
  // architecture; only the data sources are swapped for local mocks that
  // return fictional data (lib/core/demo/). The Dio-based "remote" data
  // source classes still exist in the codebase as a reference implementation
  // of the networking layer, but they are NOT registered here, and their
  // base URL is the reserved (unresolvable) `example.invalid` domain.
  // -------------------------------------------------------------------------
  assert(DemoMode.enabled, 'This portfolio build must run in DEMO MODE.');

  sl.registerLazySingleton<DioClient>(() => DioClient(sl()));

  sl.registerLazySingleton<AuthRemoteDataSource>(() => DemoAuthDataSource());

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), tokenStorage: sl()),
  );

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<CheckAuthStatus>(
    () => CheckAuthStatus(sl<AuthRepository>()),
  );
  sl.registerFactory<AutoAuthCubit>(() => AutoAuthCubit(sl()));

  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => DemoProfileDataSource(),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));

  // Reports Feature Registration
  sl.registerLazySingleton<ReportsRemoteDataSource>(
    () => DemoReportsDataSource(),
  );
  sl.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(sl()),
  );
  sl.registerFactory<ReportsCubit>(() => ReportsCubit(sl()));

  // ScanQrCode Feature Registration
  sl.registerLazySingleton<ScanQrRemoteDataSource>(
    () => DemoScanQrDataSource(),
  );

  sl.registerLazySingleton<ScanQrRepository>(() => ScanQrRepositoryImpl(sl()));

  sl.registerFactory<ScanQrCubit>(() => ScanQrCubit(sl()));

  // Lessons Feature Registration
  sl.registerLazySingleton<LessonsRemoteDataSource>(
    () => DemoLessonsDataSource(),
  );
  sl.registerLazySingleton<LessonsRepository>(
    () => LessonsRepositoryImpl(sl()),
  );
  sl.registerFactory<LessonsCubit>(() => LessonsCubit(sl()));
  sl.registerFactory<LessonDetailCubit>(() => LessonDetailCubit(sl()));

  // Notes Feature Registration (Local DB)
  sl.registerLazySingleton<NotesDatabase>(() => NotesDatabase.instance);
  sl.registerLazySingleton<LessonNotesRepository>(
    () => LessonNotesRepositoryImpl(sl()),
  );
  sl.registerFactory<LessonNotesCubit>(() => LessonNotesCubit(sl()));

  // Update Feature Registration
  sl.registerLazySingleton<ReleaseRemoteDataSource>(
    () => DemoReleaseDataSource(),
  );
  sl.registerLazySingleton<UpdateRepository>(() => UpdateRepositoryImpl(sl()));
  sl.registerLazySingleton<ApkInstaller>(() => ApkInstaller());
  sl.registerFactory<GetLatestRelease>(
    () => GetLatestRelease(sl<UpdateRepository>()),
  );
  sl.registerFactory<DownloadReleaseApk>(
    () => DownloadReleaseApk(sl<UpdateRepository>()),
  );
  sl.registerFactory<UpdateCubit>(
    () => UpdateCubit(
      sl<GetLatestRelease>(),
      sl<DownloadReleaseApk>(),
      sl<ApkInstaller>(),
    ),
  );
}
