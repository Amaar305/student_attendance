import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/login/login.dart';

class LoginRepositoryImpl implements LoginRepository {
  const LoginRepositoryImpl(this.remoteDataSource);

  final LoginRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final appUser = await remoteDataSource.getUser(id: user.uid);

      return Right(appUser);
    } on FirebaseAuthException catch (error) {
      return Left(ServerFailure(error.message ?? 'Authentication failed'));
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Authentication failed'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
