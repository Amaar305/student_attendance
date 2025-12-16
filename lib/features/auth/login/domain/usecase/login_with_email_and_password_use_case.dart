import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

import '../repository/login_repository.dart';

class LoginWithEmailAndPasswordUseCase
    implements UseCase<AppUser, LoginWithEmailAndPasswordParams> {
  const LoginWithEmailAndPasswordUseCase(this._loginRepository);

  final LoginRepository _loginRepository;

  @override
  Future<Either<Failure, AppUser>> call(
    LoginWithEmailAndPasswordParams params,
  ) {
    return _loginRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailAndPasswordParams {
  const LoginWithEmailAndPasswordParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
