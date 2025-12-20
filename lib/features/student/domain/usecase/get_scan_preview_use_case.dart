import 'package:fpdart/fpdart.dart';
import 'package:shared/shared.dart';
import 'package:student_attendance/features/student/student.dart';


class GetScanPreviewUseCase
    implements UseCase<ScanPreview, GetScanPreviewParams> {
  const GetScanPreviewUseCase(this._studentRepository);

  final StudentRepository _studentRepository;

  @override
  Future<Either<Failure, ScanPreview>> call(GetScanPreviewParams param) {
    return _studentRepository.getScanPreview(qrPayload: param.qrPayload);
  }
}


class GetScanPreviewParams {
  const GetScanPreviewParams({required this.qrPayload});

  final String qrPayload;
}
