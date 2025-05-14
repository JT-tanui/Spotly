// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './injection.dart'; // Import to reuse the same GetIt instance
import '../../core/mocks/firebase_mocks.dart'; // Import our mock implementation
import '../../data/datasources/local/auth_local_data_source.dart';
import '../../data/datasources/remote/auth_remote_data_source.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';

// Use the getIt instance from injection.dart
// final getIt = GetIt.instance;

Future<void> configureAuthDependencies() async {
  // Firebase services - using our mock implementations
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // SharedPreferences for local storage - use the existing instance from main injection
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // Create a dummy Box for UserModel since we're having issues with Hive typing
  // In a real app with proper Hive setup, we would use:
  // final userBox = await Hive.openBox<UserModel>('users');
  getIt.registerLazySingleton<Box<UserModel>>(() {
    // This is a simplified approach that uses a fake box that just works with SharedPreferences
    // as a fallback since we're having Hive adapter issues
    print('Using SharedPreferences-based user storage instead of Hive');
    return FakeUserModelBox(sharedPreferences);
  });

  // Auth data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt(),
      firestore: getIt(),
    ),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
      userBox: getIt(),
    ),
  );

  // Auth repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );

  // Auth BLoC
  getIt.registerFactory(() => AuthBloc(getIt()));
}

/// A simple implementation of Box<UserModel> that uses SharedPreferences
/// This is just a temporary workaround for the demo
class FakeUserModelBox implements Box<UserModel> {
  final SharedPreferences prefs;
  static const String KEY_PREFIX = 'fake_user_box_';
  static const String CURRENT_USER_KEY = '${KEY_PREFIX}current_user';

  FakeUserModelBox(this.prefs);

  @override
  String get name => 'fake_users';

  @override
  bool get isOpen => true;

  @override
  Iterable<UserModel> get values {
    final jsonStr = prefs.getString(CURRENT_USER_KEY);
    if (jsonStr != null) {
      try {
        return [
          UserModel.fromJson(Map<String, dynamic>.from(jsonDecode(jsonStr)))
        ];
      } catch (e) {
        print('Error parsing stored user: $e');
      }
    }
    return [];
  }

  @override
  Future<int> add(UserModel user) async {
    // Just store the current user for our simplified case
    await prefs.setString(CURRENT_USER_KEY, jsonEncode(user.toJson()));
    return 0;
  }

  @override
  Future<int> clear() async {
    await prefs.remove(CURRENT_USER_KEY);
    return 0;
  }

  // Implement remaining methods with minimal functionality
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #isEmpty) return values.isEmpty;
    if (invocation.memberName == #isNotEmpty) return values.isNotEmpty;
    if (invocation.memberName == #length) return values.length;

    // For all other methods, return stub values
    if (invocation.isGetter) return null;
    if (invocation.isSetter) return null;

    // For method calls
    if (invocation.isMethod) {
      final returnType = invocation.memberName.toString();
      if (returnType.contains('Future<void>')) return Future.value();
      if (returnType.contains('Future<int>')) return Future.value(0);
      if (returnType.contains('Future<')) return Future.value(null);
      if (returnType.contains('void')) return null;
      if (returnType.contains('Stream')) return Stream.empty();
      return null;
    }

    return null;
  }
}
