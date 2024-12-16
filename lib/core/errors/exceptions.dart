class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class NetworkException implements Exception {
  String message;
  NetworkException(this.message);
}

class EmptyCacheException implements Exception {
  String message;
  EmptyCacheException(this.message);
}

class ServerException implements Exception {
  String message;
  ServerException(this.message);
}
