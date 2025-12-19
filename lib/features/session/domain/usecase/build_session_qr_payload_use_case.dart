import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

import '../repository/session_repository.dart';

class BuildSessionQrPayloadUseCase
    implements UseCase<String, BuildSessionQrPayloadParams> {
  const BuildSessionQrPayloadUseCase(this._sessionRepository);

  final SessionRepository _sessionRepository;

  @override
  Future<Either<Failure, String>> call(
    BuildSessionQrPayloadParams param,
  ) async {
    final payload = _sessionRepository.buildQrPayload(
      sessionId: param.sessionId,
      qrToken: param.qrToken,
    );

    return right(payload);
  }
}

class BuildSessionQrPayloadParams {
  const BuildSessionQrPayloadParams({
    required this.sessionId,
    required this.qrToken,
  });

  final String sessionId;
  final String qrToken;
}
