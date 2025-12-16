// ignore_for_file: public_member_api_docs

class ServerException implements Exception {
  ServerException(this.message);
  final String message;

  @override
  String toString() {
    return message;
  }
}

class CacheException implements Exception {
  CacheException(this.message);
  final String message;

  @override
  String toString() {
    return message;
  }
}
