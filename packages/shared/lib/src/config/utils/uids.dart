// ignore_for_file: public_member_api_docs

import 'package:uuid/uuid.dart';

class Uids {
  const Uids._();

  static String get uidV4 => const Uuid().v4();
}
