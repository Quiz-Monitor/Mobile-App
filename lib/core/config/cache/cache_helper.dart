import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_constants.dart';

class CacheHelper {
  CacheHelper._();

  static SharedPreferences? _sharedPreferences;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: CacheConstants.accessToken, value: token);
  }

  static Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: CacheConstants.refreshToken, value: token);
  }

  static Future<String?> getAccessToken() async {
    return _secureStorage.read(key: CacheConstants.accessToken);
  }

  static Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: CacheConstants.refreshToken);
  }

  static Future<void> removeAccessToken() async {
    await _secureStorage.delete(key: CacheConstants.accessToken);
  }

  static Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: CacheConstants.refreshToken);
  }

  static Future<void> saveString(String key, String value) async {
    await _sharedPreferences?.setString(key, value);
  }

  static String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  static Future<void> saveInt(String key, int value) async {
    await _sharedPreferences?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _sharedPreferences?.getInt(key);
  }

  static Future<void> remove(String key) async {
    await _sharedPreferences?.remove(key);
  }

  static Future<void> clearSessionData() async {
    await removeAccessToken();
    await removeRefreshToken();

    await remove(CacheConstants.role);
    await remove(CacheConstants.userId);
    await remove(CacheConstants.fullName);
    await remove(CacheConstants.email);
  }
}
