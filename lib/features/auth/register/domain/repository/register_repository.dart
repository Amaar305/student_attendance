import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

abstract interface class RegisterRepository {
  Future<Either<Failure, AppUser>> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
    String? studentID,
    String? staffID,
  });
}
