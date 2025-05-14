import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  final String message;

  const ServerFailure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

class CacheFailure extends Failure {
  final String message;

  const CacheFailure([this.message = 'Cache error occurred']);

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  final String message;

  const NetworkFailure([this.message = 'Network error occurred']);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  final String message;

  const AuthFailure([this.message = 'Authentication error occurred']);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure([this.message = 'Validation error occurred']);

  @override
  List<Object?> get props => [message];
}

class PermissionFailure extends Failure {
  final String message;

  const PermissionFailure([this.message = 'Permission denied']);

  @override
  List<Object?> get props => [message];
}

class LocationFailure extends Failure {
  final String message;

  const LocationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class EventFailure extends Failure {
  final String message;

  const EventFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class NotFoundFailure extends Failure {
  final String message;

  const NotFoundFailure([this.message = 'Resource not found']);

  @override
  List<Object?> get props => [message];
}

class TimeoutFailure extends Failure {
  final String message;

  const TimeoutFailure([this.message = 'Request timed out']);

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  final String message;

  const UnknownFailure([this.message = 'An unknown error occurred']);

  @override
  List<Object?> get props => [message];
}
