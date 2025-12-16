import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/auth/auth.dart';

class RegisterWithDetailsUseCase
    implements UseCase<AppUser, RegisterWithDetailsParams> {
  final RegisterRepository registerRepository;

  const RegisterWithDetailsUseCase({required this.registerRepository});

  @override
  Future<Either<Failure, AppUser>> call(RegisterWithDetailsParams param) async {
    return await registerRepository.register(
      fullName: param.fullName,
      email: param.email,
      password: param.password,
      role: param.role,
      staffID: param.staffID,
      studentID: param.studentID,
    );
  }
}

class RegisterWithDetailsParams {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String? studentID;
  final String? staffID;

  const RegisterWithDetailsParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.studentID,
    this.staffID,
  });
}
