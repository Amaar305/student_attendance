import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:student_attendance/app/cubit/app_cubit.dart';
import 'package:student_attendance/features/auth/auth.dart';
import 'package:student_attendance/features/session/session.dart';


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
  _session();
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
    ..registerFactory<CloseSessionUseCase>(
      () => CloseSessionUseCase(getIt()),
    )
    ..registerFactory<CreateOrGetOpenSessionUseCase>(
      () => CreateOrGetOpenSessionUseCase(getIt()),
    )
    ..registerFactory<FetchLecturerCoursesUseCase>(
      () => FetchLecturerCoursesUseCase(getIt()),
    );
}
