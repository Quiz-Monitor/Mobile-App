import 'package:examify/core/config/cache/cache_constants.dart';
import 'package:examify/core/config/cache/cache_helper.dart';

abstract class SessionStorage {
  Future<void> saveSession({
    String? accessToken,
    String? refreshToken,
    String? role,
    int? userId,
    String? fullName,
    String? email,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> saveAccessToken(String accessToken);

  Future<void> saveRefreshToken(String refreshToken);

  Future<void> deleteAccessToken();

  Future<void> deleteRefreshToken();

  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
  });

  Future<String?> getRole();

  Future<int?> getUserId();

  Future<String?> getFullName();

  Future<String?> getEmail();

  Future<void> clearSession();
}

class SecureSessionStorage implements SessionStorage {
  @override
  Future<void> saveSession({
    String? accessToken,
    String? refreshToken,
    String? role,
    int? userId,
    String? fullName,
    String? email,
  }) async {
    if (accessToken != null && accessToken.isNotEmpty) {
      await CacheHelper.setAccessToken(accessToken);
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await CacheHelper.setRefreshToken(refreshToken);
    }

    if (role != null) {
      await CacheHelper.saveString(CacheConstants.role, role);
    }

    if (userId != null) {
      await CacheHelper.saveInt(CacheConstants.userId, userId);
    }

    if (fullName != null) {
      await CacheHelper.saveString(CacheConstants.fullName, fullName);
    }

    if (email != null) {
      await CacheHelper.saveString(CacheConstants.email, email);
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return CacheHelper.getAccessToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return CacheHelper.getRefreshToken();
  }

  @override
  Future<void> saveAccessToken(String accessToken) async {
    await CacheHelper.setAccessToken(accessToken);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await CacheHelper.setRefreshToken(refreshToken);
  }

  @override
  Future<void> deleteAccessToken() async {
    await CacheHelper.removeAccessToken();
  }

  @override
  Future<void> deleteRefreshToken() async {
    await CacheHelper.removeRefreshToken();
  }

  @override
  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await saveRefreshToken(refreshToken);
    }
  }

  @override
  Future<String?> getRole() async {
    return CacheHelper.getString(CacheConstants.role);
  }

  @override
  Future<int?> getUserId() async {
    return CacheHelper.getInt(CacheConstants.userId);
  }

  @override
  Future<String?> getFullName() async {
    return CacheHelper.getString(CacheConstants.fullName);
  }

  @override
  Future<String?> getEmail() async {
    return CacheHelper.getString(CacheConstants.email);
  }

  @override
  Future<void> clearSession() async {
    await CacheHelper.clearSessionData();
  }
}

class InMemorySessionStorage implements SessionStorage {
  String? _accessToken;
  String? _refreshToken;
  String? _role;
  int? _userId;
  String? _fullName;
  String? _email;

  @override
  Future<void> saveSession({
    String? accessToken,
    String? refreshToken,
    String? role,
    int? userId,
    String? fullName,
    String? email,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _role = role;
    _userId = userId;
    _fullName = fullName;
    _email = email;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<void> saveAccessToken(String accessToken) async {
    _accessToken = accessToken;
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    _refreshToken = refreshToken;
  }

  @override
  Future<void> deleteAccessToken() async {
    _accessToken = null;
  }

  @override
  Future<void> deleteRefreshToken() async {
    _refreshToken = null;
  }

  @override
  Future<void> updateTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _accessToken = accessToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      _refreshToken = refreshToken;
    }
  }

  @override
  Future<String?> getRole() async => _role;

  @override
  Future<int?> getUserId() async => _userId;

  @override
  Future<String?> getFullName() async => _fullName;

  @override
  Future<String?> getEmail() async => _email;

  @override
  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    _role = null;
    _userId = null;
    _fullName = null;
    _email = null;
  }
}
