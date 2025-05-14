import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  /// Get the cached user
  Future<UserModel?> getUser();

  /// Cache the user data
  Future<void> cacheUser(UserModel user);

  /// Clear the cached user data
  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box<UserModel> userBox;

  static const String USER_KEY = 'CACHED_USER';
  static const String USER_BOX = 'user_box';

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.userBox,
  });

  @override
  Future<UserModel?> getUser() async {
    try {
      // First try to get from Hive
      if (userBox.isOpen && userBox.isNotEmpty) {
        return userBox.values.first;
      }

      // Fallback to SharedPreferences if Hive doesn't have the user
      final jsonString = sharedPreferences.getString(USER_KEY);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      }

      return null;
    } catch (e) {
      throw CacheException(
          message: 'Failed to get cached user: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      // Cache to both Hive and SharedPreferences for redundancy
      if (userBox.isOpen) {
        await userBox.clear();
        await userBox.add(user);
      }

      // Always cache to SharedPreferences as fallback
      await sharedPreferences.setString(USER_KEY, json.encode(user.toJson()));
    } catch (e) {
      throw CacheException(message: 'Failed to cache user: ${e.toString()}');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      // Clear from both storages
      if (userBox.isOpen) {
        await userBox.clear();
      }

      await sharedPreferences.remove(USER_KEY);
    } catch (e) {
      throw CacheException(message: 'Failed to clear user: ${e.toString()}');
    }
  }
}
