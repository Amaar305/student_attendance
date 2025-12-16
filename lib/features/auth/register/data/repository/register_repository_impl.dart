import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/register/register.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource registerRemoteDataSource;

  const RegisterRepositoryImpl({required this.registerRemoteDataSource});

  @override
  Future<Either<Failure, AppUser>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? studentID,
    String? staffID,
  }) async {
    try {
      final staffStudentID = studentID ?? staffID;

      if (staffStudentID != null && staffStudentID.isNotEmpty) {
        final exists = await registerRemoteDataSource.isStaffStudentIDExits(
          staffStudentID: staffStudentID,
        );

        if (exists) {
          return const Left(
            ServerFailure('Student/Staff ID already exists'),
          );
        }
      }

      await registerRemoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await registerRemoteDataSource.createUserRecord(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        studentID: studentID,
        staffID: staffID,
      );

      return Right(user);
    } on FirebaseAuthException catch (error) {
      return Left(ServerFailure(error.message ?? 'Registration failed'));
    } on FirebaseException catch (error) {
      return Left(ServerFailure(error.message ?? 'Registration failed'));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
