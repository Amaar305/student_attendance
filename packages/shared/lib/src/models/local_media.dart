// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class LocalMedia {
  LocalMedia({
    required this.type,
    required this.file,
    required this.blurHash,
  });

  final LocalMediaType type;
  final File file;
  final String blurHash;

  LocalMedia copyWith({
    LocalMediaType? type,
    File? file,
    String? blurHash,
  }) {
    return LocalMedia(
      type: type ?? this.type,
      file: file ?? this.file,
      blurHash: blurHash ?? this.blurHash,
    );
  }
}

enum LocalMediaType { image, video }
