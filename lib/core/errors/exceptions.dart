class CommonException implements Exception {
  final String message;
  const CommonException(this.message);
}

class AuthException extends CommonException {
  const AuthException(super.message);
}

class NetworkException extends CommonException {
  const NetworkException(super.message);
}

class EmptyCacheException extends CommonException {
  const EmptyCacheException(super.message);
}

class ServerException extends CommonException {
  const ServerException(super.message);
}
