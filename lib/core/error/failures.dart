import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = '']);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error occurred'])
      : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
      : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation error occurred'])
      : super(message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(
      [String message = 'Authentication error occurred'])
      : super(message);
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure([String message = 'Authorization error occurred'])
      : super(message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
      : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unknown error occurred'])
      : super(message);
}
