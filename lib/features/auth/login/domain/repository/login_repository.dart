import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

abstract interface class LoginRepository {
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });
}
