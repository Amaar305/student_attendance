// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class RefreshTokenFailure extends Failure {
  const RefreshTokenFailure(super.message);
}
