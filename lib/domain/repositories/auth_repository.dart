import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with Apple
  Future<Either<Failure, User>> signInWithApple();

  /// Sign in with Facebook
  Future<Either<Failure, User>> signInWithFacebook();

  /// Sign up with email and password
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Get the currently signed in user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Reset password for the given email
  Future<Either<Failure, void>> resetPassword(String email);

  /// Update user profile information
  Future<Either<Failure, User>> updateProfile({
    required String name,
    String? photoUrl,
    String? bio,
  });

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();

  /// Check if user is signed in
  Future<Either<Failure, bool>> isSignedIn();
}
