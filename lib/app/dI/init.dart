import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';
import 'package:student_attendance/features/auth/auth.dart';
import 'package:student_attendance/features/lecturer/lecturer.dart';
import 'package:student_attendance/features/session/session.dart';
import 'package:student_attendance/features/student/student.dart';

GetIt getIt = GetIt.instance;

void initDependencies() async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Firebase
  getIt
    ..registerLazySingleton(() => firebaseAuth)
    ..registerLazySingleton(() => firestore);

  getIt.registerLazySingleton(
    () => AppCubit(
      firebaseAuth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  _auth();
  _lecturer();
  _session();
  _student();
}

void _auth() {
  _login();
  _register();
}

void _register() {
  // Datasource
  getIt
    ..registerFactory<RegisterRemoteDataSource>(
      () => RegisterRemoteDataSourceImpl(
        firestore: getIt<FirebaseFirestore>(),
        firebaseAuth: getIt<FirebaseAuth>(),
      ),
    )
    // Repository
    ..registerFactory<RegisterRepository>(
      () => RegisterRepositoryImpl(registerRemoteDataSource: getIt()),
    )
    // Usecase
    ..registerFactory<RegisterWithDetailsUseCase>(
      () => RegisterWithDetailsUseCase(registerRepository: getIt()),
    );
}

void _login() {
  getIt
    ..registerFactory<LoginRemoteDataSource>(
      () => LoginRemoteDataSourceImpl(
        firebaseAuth: getIt<FirebaseAuth>(),
        firestore: getIt<FirebaseFirestore>(),
      ),
    )
    ..registerFactory<LoginRepository>(
      () => LoginRepositoryImpl(getIt<LoginRemoteDataSource>()),
    )
    ..registerFactory<LoginWithEmailAndPasswordUseCase>(
      () => LoginWithEmailAndPasswordUseCase(getIt<LoginRepository>()),
    );
}

void _lecturer() {
  getIt
    ..registerFactory<LecturerRemoteDataSource>(
      () => LecturerRemoteDataSourceImpl(
        firebaseFirestore: getIt<FirebaseFirestore>(),
      ),
    )
    ..registerFactory<LecturerRepository>(
      () => LecturerRepositoryImpl(lecturerRemoteDataSource: getIt()),
    )
    ..registerFactory<WatchLecturerCoursesUseCase>(
      () => WatchLecturerCoursesUseCase(lecturerRepository: getIt()),
    )
    ..registerFactory<GetCourseStudentCountUseCase>(
      () => GetCourseStudentCountUseCase(lecturerRepository: getIt()),
    )
    ..registerFactory<AddCourseUseCase>(
      () => AddCourseUseCase(lecturerRepository: getIt()),
    )
    ..registerFactory<WatchSessionAttendanceCountUseCase>(
      () => WatchSessionAttendanceCountUseCase(lecturerRepository: getIt()),
    )
    ..registerFactory<WatchCourseStudentCountUseCase>(
      () => WatchCourseStudentCountUseCase(lecturerRepository: getIt()),
    )
    ..registerFactory<WatchCourseSessionsUseCase>(
      () => WatchCourseSessionsUseCase(lecturerRepository: getIt()),
    )
    ..registerFactory<GetSessionStudentAttendanceUseCase>(
      () => GetSessionStudentAttendanceUseCase(lecturerRepository: getIt()),
    );
}

void _session() {
  getIt
    ..registerFactory<SessionRemoteDataSource>(
      () => SessionDataSourceImpl(firestore: getIt<FirebaseFirestore>()),
    )
    ..registerFactory<SessionRepository>(
      () => SessionRepositoryImpl(remoteDataSource: getIt()),
    )
    ..registerFactory<BuildSessionQrPayloadUseCase>(
      () => BuildSessionQrPayloadUseCase(getIt()),
    )
    ..registerFactory<CloseSessionUseCase>(() => CloseSessionUseCase(getIt()))
    ..registerFactory<CreateOrGetOpenSessionUseCase>(
      () => CreateOrGetOpenSessionUseCase(getIt()),
    )
    ..registerFactory<FetchLecturerCoursesUseCase>(
      () => FetchLecturerCoursesUseCase(getIt()),
    );
}

void _student() {
  getIt
    ..registerFactory<StudentRemoteDatasource>(
      () => StudentRemoteDatasourceImpl(
        firebaseFirestore: getIt<FirebaseFirestore>(),
      ),
    )
    ..registerFactory<StudentRepository>(
      () => StudentRepositoryImpl(studentRemoteDatasource: getIt()),
    )
    ..registerFactory<EnrollInCourseUseCase>(
      () => EnrollInCourseUseCase(getIt()),
    )
    ..registerFactory<IsStudentEnrolledUseCase>(
      () => IsStudentEnrolledUseCase(getIt()),
    )
    ..registerFactory<WatchEnrolledCourseIdsUseCase>(
      () => WatchEnrolledCourseIdsUseCase(getIt()),
    )
    ..registerFactory<WatchTodaySessionsForStudentUseCase>(
      () => WatchTodaySessionsForStudentUseCase(getIt()),
    )
    ..registerFactory<GetScanPreviewUseCase>(
      () => GetScanPreviewUseCase(getIt()),
    )
    ..registerFactory<ConfirmAttendanceUseCase>(
      () => ConfirmAttendanceUseCase(getIt()),
    )
    ..registerFactory<WatchStudentCourseOptionsUseCase>(
      () => WatchStudentCourseOptionsUseCase(getIt()),
    )
    ..registerFactory<WatchCoursesUseCase>(
      () => WatchCoursesUseCase(studentRepository: getIt()),
    )
    ..registerFactory<WatchMyAttendanceForSessionsUseCase>(
      () => WatchMyAttendanceForSessionsUseCase(studentRepository: getIt()),
    )
    ..registerFactory<WatchAttendanceHistoryUseCase>(
      () => WatchAttendanceHistoryUseCase(studentRepository: getIt()),
    );
}
