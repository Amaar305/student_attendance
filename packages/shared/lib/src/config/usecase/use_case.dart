// ignore_for_file: one_member_abstracts, public_member_api_docs

import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';

/// Generic interface for a use case with input parameter and success type.
abstract interface class UseCase<SuccessType, Param> {
  Future<Either<Failure, SuccessType>> call(Param param);
}
abstract interface class UseCaseStream<SuccessType, Param> {
  Stream<Either<Failure, SuccessType>> call(Param param);
}

/// Generic interface for a use case with no input parameter.
class NoParam {}
