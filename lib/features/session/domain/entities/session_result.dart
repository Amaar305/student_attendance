import 'package:shared/shared.dart';

class SessionResult {
  final Session session;
  final String qrPayload;
  final Course course;

  SessionResult({
    required this.session,
    required this.qrPayload,
    required this.course,
  });
}
