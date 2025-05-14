// Import our mock implementation instead of the real Firebase
// import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/mocks/firebase_mocks.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signInWithEmail(String email, String password);

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail(String email, String password, String name);

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign in with Apple
  Future<UserModel> signInWithApple();

  /// Sign in with Facebook
  Future<UserModel> signInWithFacebook();

  /// Sign out the current user
  Future<void> signOut();

  /// Get the currently signed in user
  Future<UserModel?> getCurrentUser();

  /// Reset password for the given email
  Future<void> resetPassword(String email);

  /// Update user profile information
  Future<UserModel> updateProfile(UserModel user);

  /// Delete user account
  Future<void> deleteAccount();

  /// Check if user is signed in
  Future<bool> isSignedIn();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(message: 'Sign in failed');
      }

      // Update last sign in timestamp
      final user = userCredential.user!;
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        await firestore.collection('users').doc(user.uid).update({
          'last_sign_in_at': DateTime.now().toIso8601String(),
        });
      }

      // Get user data from Firestore
      final userData = await _getUserData(user.uid);
      return userData;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Authentication error',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(
      String email, String password, String name) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(message: 'Sign up failed');
      }

      final user = userCredential.user!;

      // Set display name
      await user.updateDisplayName(name);

      // Create user document in Firestore
      final now = DateTime.now();
      final nowString = now.toIso8601String();
      await firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': name,
        'email': email,
        'photo_url': user.photoURL,
        'created_at': nowString,
        'updated_at': nowString,
        'bio': null,
      });

      return UserModel(
        id: user.uid,
        name: name,
        email: email,
        photoUrl: user.photoURL,
        bio: null,
        createdAt: now,
        updatedAt: now,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Authentication error',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // This is a mock implementation
      final userCredential = await firebaseAuth.signInWithGoogle();

      if (userCredential.user == null) {
        throw AuthException(message: 'Google sign in failed');
      }

      final user = userCredential.user!;

      // Check if the user already exists in Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create new user document
        final now = DateTime.now();
        await firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName ?? 'Google User',
          'email': user.email!,
          'photo_url': user.photoURL,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
          'bio': null,
        });
      } else {
        // Update sign in timestamp
        await firestore.collection('users').doc(user.uid).update({
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      return await _getUserData(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Google authentication error',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Google sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      // This is a mock implementation
      final userCredential = await firebaseAuth.signInWithApple();

      if (userCredential.user == null) {
        throw AuthException(message: 'Apple sign in failed');
      }

      final user = userCredential.user!;

      // Check if the user already exists in Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create new user document
        final now = DateTime.now();
        await firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName ?? 'Apple User',
          'email': user.email!,
          'photo_url': user.photoURL,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
          'bio': null,
        });
      } else {
        // Update sign in timestamp
        await firestore.collection('users').doc(user.uid).update({
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      return await _getUserData(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Apple authentication error',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Apple sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    try {
      // This is a mock implementation
      final userCredential = await firebaseAuth.signInWithFacebook();

      if (userCredential.user == null) {
        throw AuthException(message: 'Facebook sign in failed');
      }

      final user = userCredential.user!;

      // Check if the user already exists in Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Create new user document
        final now = DateTime.now();
        await firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': user.displayName ?? 'Facebook User',
          'email': user.email!,
          'photo_url': user.photoURL,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
          'bio': null,
        });
      } else {
        // Update sign in timestamp
        await firestore.collection('users').doc(user.uid).update({
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      return await _getUserData(user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Facebook authentication error',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Facebook sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(message: 'Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }

      return await _getUserData(user.uid);
    } catch (e) {
      throw AuthException(
          message: 'Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Password reset failed',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        throw AuthException(message: 'No authenticated user found');
      }

      // Update display name if changed
      if (user.name != currentUser.displayName) {
        await currentUser.updateDisplayName(user.name);
      }

      // Update photo URL if changed
      if (user.photoUrl != currentUser.photoURL && user.photoUrl != null) {
        await currentUser.updatePhotoURL(user.photoUrl);
      }

      // Update user document in Firestore
      await firestore.collection('users').doc(user.id).update({
        'name': user.name,
        'photo_url': user.photoUrl,
        // Don't update email here as it requires additional verification
      });

      return user;
    } catch (e) {
      throw AuthException(message: 'Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final currentUser = firebaseAuth.currentUser;

      if (currentUser == null) {
        throw AuthException(message: 'No authenticated user found');
      }

      // Delete user document from Firestore
      await firestore.collection('users').doc(currentUser.uid).delete();

      // Delete Firebase Auth account
      await currentUser.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        message: e.message ?? 'Failed to delete account',
        code: e.code,
      );
    } catch (e) {
      throw AuthException(message: 'Failed to delete account: ${e.toString()}');
    }
  }

  @override
  Future<bool> isSignedIn() async {
    return firebaseAuth.currentUser != null;
  }

  /// Helper method to fetch user data from Firestore
  Future<UserModel> _getUserData(String uid) async {
    try {
      final userDoc = await firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // If user document doesn't exist, create it from Firebase Auth data
        final user = firebaseAuth.currentUser!;
        final now = DateTime.now().toIso8601String();

        final userData = {
          'id': user.uid,
          'name': user.displayName ?? 'User',
          'email': user.email!,
          'photo_url': user.photoURL,
          'created_at': now,
          'last_sign_in_at': now,
          'is_email_verified': user.emailVerified,
        };

        await firestore.collection('users').doc(uid).set(userData);

        return UserModel.fromJson(userData);
      }

      final data = userDoc.data()!;
      data['id'] = uid; // Ensure ID is set

      return UserModel.fromJson(data);
    } catch (e) {
      throw AuthException(message: 'Failed to get user data: ${e.toString()}');
    }
  }
}
