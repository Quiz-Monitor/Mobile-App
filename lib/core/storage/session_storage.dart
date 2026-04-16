abstract class SessionStorage {
  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    String? role,
    int? userId,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<String?> getRole();

  Future<int?> getUserId();

  Future<void> clearSession();
}

class InMemorySessionStorage implements SessionStorage {
  String? _accessToken;
  String? _refreshToken;
  String? _role;
  int? _userId;

  @override
  Future<void> saveSession({
    required String accessToken,
    String? refreshToken,
    String? role,
    int? userId,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _role = role;
    _userId = userId;
  }

  @override
  Future<String?> getAccessToken() async => _accessToken;

  @override
  Future<String?> getRefreshToken() async => _refreshToken;

  @override
  Future<String?> getRole() async => _role;

  @override
  Future<int?> getUserId() async => _userId;

  @override
  Future<void> clearSession() async {
    _accessToken = null;
    _refreshToken = null;
    _role = null;
    _userId = null;
  }
}
