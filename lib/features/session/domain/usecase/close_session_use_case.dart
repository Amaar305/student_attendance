import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

import '../repository/session_repository.dart';

class CloseSessionUseCase implements UseCase<void, CloseSessionParams> {
  const CloseSessionUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  @override
  Future<Either<Failure, void>> call(CloseSessionParams param) {
    return _sessionRepository.closeSession(sessionId: param.sessionId);
  }
}

class CloseSessionParams {
  const CloseSessionParams({required this.sessionId});

  final String sessionId;
}
