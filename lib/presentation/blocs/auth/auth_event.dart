import 'package:equatable/equatable.dart';
import '../../../domain/entities/user.dart';

abstract class AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent({
    required this.email,
    required this.password,
  });
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithAppleEvent extends AuthEvent {}

class SignInWithFacebookEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUpWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
  });
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});
}

class UpdateProfileEvent extends AuthEvent {
  final String name;
  final String? photoUrl;
  final String? bio;

  UpdateProfileEvent({
    required this.name,
    this.photoUrl,
    this.bio,
  });
}

class DeleteAccountEvent extends AuthEvent {}
