import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

import '../repository/session_repository.dart';

class FetchLecturerCoursesUseCase
    implements UseCase<List<Course>, FetchLecturerCoursesParams> {
  const FetchLecturerCoursesUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  @override
  Future<Either<Failure, List<Course>>> call(
    FetchLecturerCoursesParams param,
  ) {
    return _sessionRepository.fetchLecturerCourses(
      lecturerId: param.lecturerId,
    );
  }
}

class FetchLecturerCoursesParams {
  const FetchLecturerCoursesParams({required this.lecturerId});

  final String lecturerId;
}
