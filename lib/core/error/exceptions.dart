class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server error occurred']);
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error occurred']);
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Network error occurred']);
}

class ValidationException implements Exception {
  final String message;

  ValidationException([this.message = 'Validation error occurred']);
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException([this.message = 'Authentication error occurred']);
}

class AuthorizationException implements Exception {
  final String message;

  AuthorizationException([this.message = 'Authorization error occurred']);
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found']);
}

class UnknownException implements Exception {
  final String message;

  UnknownException([this.message = 'An unknown error occurred']);
}
