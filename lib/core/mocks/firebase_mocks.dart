// This file provides mock implementations of Firebase Auth and Firestore
// for development and testing without actual Firebase connections

import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock Firebase Auth User
class FirebaseUser {
  final String uid;
  final String? email;
  String? displayName;
  String? photoURL;
  final bool emailVerified;

  FirebaseUser(
      {required this.uid,
      this.email,
      this.displayName,
      this.photoURL,
      this.emailVerified = false});

  Future<void> updateDisplayName(String? name) async {
    displayName = name;
  }

  Future<void> updatePhotoURL(String? url) async {
    photoURL = url;
  }

  Future<void> delete() async {
    // Mock user deletion
  }
}

/// Mock UserCredential to match Firebase Auth structure
class UserCredential {
  final FirebaseUser? user;

  UserCredential({this.user});
}

/// Mock FirebaseAuth exception to match Firebase Auth exceptions
class FirebaseAuthException implements Exception {
  final String code;
  final String? message;

  FirebaseAuthException({required this.code, this.message});
}

/// Mock FirebaseAuth implementation
class FirebaseAuth {
  static final FirebaseAuth _instance = FirebaseAuth._();
  static FirebaseAuth get instance => _instance;

  FirebaseAuth._();

  FirebaseUser? _currentUser;
  FirebaseUser? get currentUser => _currentUser;

  // Mock local storage key
  static const String _userStorageKey = 'mock_firebase_user';

  // Load user from local storage
  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);
      if (userJson != null) {
        final userData = json.decode(userJson);
        _currentUser = FirebaseUser(
          uid: userData['uid'],
          email: userData['email'],
          displayName: userData['displayName'],
          photoURL: userData['photoURL'],
          emailVerified: userData['emailVerified'] ?? false,
        );
      }
    } catch (e) {
      print('Error loading mock user: $e');
    }
  }

  // Save user to local storage
  Future<void> _saveUserToStorage() async {
    if (_currentUser == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = {
        'uid': _currentUser!.uid,
        'email': _currentUser!.email,
        'displayName': _currentUser!.displayName,
        'photoURL': _currentUser!.photoURL,
        'emailVerified': _currentUser!.emailVerified,
      };
      await prefs.setString(_userStorageKey, json.encode(userData));
    } catch (e) {
      print('Error saving mock user: $e');
    }
  }

  // Clear user from local storage
  Future<void> _clearUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userStorageKey);
    } catch (e) {
      print('Error clearing mock user: $e');
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _loadUserFromStorage();

    // For testing, we'll make a simple condition - any email with password "password123" works
    if (password != 'password123') {
      throw FirebaseAuthException(
        code: 'wrong-password',
        message: 'The password is invalid for this email.',
      );
    }

    // Create or update the current user
    _currentUser = FirebaseUser(
      uid: _generateMockUid(email),
      email: email,
      displayName: email.split('@').first,
      emailVerified: true,
    );

    await _saveUserToStorage();

    return UserCredential(user: _currentUser);
  }

  // Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // For testing, we'll store this in memory
    _currentUser = FirebaseUser(
      uid: _generateMockUid(email),
      email: email,
      displayName: null,
      photoURL: null,
      emailVerified: false,
    );

    await _saveUserToStorage();

    return UserCredential(user: _currentUser);
  }

  // Send password reset email (just a mock)
  Future<void> sendPasswordResetEmail({required String email}) async {
    print('Mock password reset email sent to $email');
  }

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
    await _clearUserFromStorage();
  }

  // Generate a deterministic user ID from email
  String _generateMockUid(String email) {
    final random = Random(email.hashCode);
    return List.generate(28, (_) => '0123456789abcdef'[random.nextInt(16)])
        .join('');
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    // Create a mock user for Google sign in
    final email =
        'google_user_${DateTime.now().millisecondsSinceEpoch}@gmail.com';

    _currentUser = FirebaseUser(
      uid: _generateMockUid(email),
      email: email,
      displayName: 'Google User',
      photoURL: 'https://placekitten.com/200/200', // Mock profile photo
      emailVerified: true,
    );

    await _saveUserToStorage();

    return UserCredential(user: _currentUser);
  }

  // Sign in with Apple
  Future<UserCredential> signInWithApple() async {
    // Create a mock user for Apple sign in
    final email =
        'apple_user_${DateTime.now().millisecondsSinceEpoch}@icloud.com';

    _currentUser = FirebaseUser(
      uid: _generateMockUid(email),
      email: email,
      displayName: 'Apple User',
      photoURL: 'https://placekitten.com/201/201', // Mock profile photo
      emailVerified: true,
    );

    await _saveUserToStorage();

    return UserCredential(user: _currentUser);
  }

  // Sign in with Facebook
  Future<UserCredential> signInWithFacebook() async {
    // Create a mock user for Facebook sign in
    final email =
        'facebook_user_${DateTime.now().millisecondsSinceEpoch}@facebook.com';

    _currentUser = FirebaseUser(
      uid: _generateMockUid(email),
      email: email,
      displayName: 'Facebook User',
      photoURL: 'https://placekitten.com/202/202', // Mock profile photo
      emailVerified: true,
    );

    await _saveUserToStorage();

    return UserCredential(user: _currentUser);
  }
}

/// Mock DocumentSnapshot
class DocumentSnapshot {
  final Map<String, dynamic>? _data;
  final String id;
  final bool exists;

  DocumentSnapshot(
      {required this.id,
      required Map<String, dynamic>? data,
      required this.exists})
      : _data = data;

  Map<String, dynamic>? data() => _data;
}

/// Mock DocumentReference
class DocumentReference {
  final String id;
  final String path;
  Map<String, dynamic>? _data;
  bool _exists = false;

  DocumentReference(this.path) : id = path.split('/').last;

  Future<DocumentSnapshot> get() async {
    // Mock implementation - in real app, this would retrieve from Firestore
    return DocumentSnapshot(
      id: id,
      data: _data,
      exists: _exists,
    );
  }

  Future<void> set(Map<String, dynamic> data) async {
    // Mock implementation
    _data = Map.from(data);
    _exists = true;

    // Save to local storage
    await _saveToStorage();
  }

  Future<void> update(Map<String, dynamic> data) async {
    if (_data == null) {
      _data = {};
      _exists = true;
    }

    _data!.addAll(data);

    // Save to local storage
    await _saveToStorage();
  }

  Future<void> delete() async {
    _data = null;
    _exists = false;

    // Remove from local storage
    await _removeFromStorage();
  }

  // Methods to persist data in SharedPreferences
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firestore_$path', json.encode(_data));
    } catch (e) {
      print('Error saving document: $e');
    }
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataString = prefs.getString('firestore_$path');
      if (dataString != null) {
        _data = json.decode(dataString);
        _exists = true;
      }
    } catch (e) {
      print('Error loading document: $e');
    }
  }

  Future<void> _removeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('firestore_$path');
    } catch (e) {
      print('Error removing document: $e');
    }
  }
}

/// Mock CollectionReference
class CollectionReference {
  final String path;

  CollectionReference(this.path);

  DocumentReference doc(String docId) {
    final docPath = '$path/$docId';
    final docRef = DocumentReference(docPath);
    docRef._loadFromStorage(); // Load existing data if available
    return docRef;
  }
}

/// Mock Firestore implementation
class FirebaseFirestore {
  static final FirebaseFirestore _instance = FirebaseFirestore._();
  static FirebaseFirestore get instance => _instance;

  FirebaseFirestore._();

  CollectionReference collection(String collectionPath) {
    return CollectionReference(collectionPath);
  }
}
