import 'package:examify/core/storage/session_storage.dart';

class SessionManager {
  SessionManager(this._sessionStorage);

  final SessionStorage _sessionStorage;

  Future<void> logout() async {
    await _sessionStorage.clearSession();
  }

  Future<void> saveProfile({
    String? role,
    int? userId,
    String? fullName,
    String? email,
  }) async {
    await _sessionStorage.saveSession(
      role: role,
      userId: userId,
      fullName: fullName,
      email: email,
    );
  }
}
