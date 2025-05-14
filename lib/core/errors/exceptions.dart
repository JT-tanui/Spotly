class ServerException implements Exception {
  final String message;
  final String? code;

  ServerException({this.message = 'Server Error', this.code});
}

class CacheException implements Exception {
  final String message;

  CacheException({this.message = 'Cache Error'});
}

class NetworkException implements Exception {
  final String message;

  NetworkException({this.message = 'Network Error'});
}

class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({this.message = 'Authentication Error', this.code});
}

class LocationException implements Exception {
  final String message;

  LocationException({this.message = 'Location Error'});
}

class PermissionException implements Exception {
  final String message;

  PermissionException({this.message = 'Permission Denied'});
}
