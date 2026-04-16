import 'package:examify/core/storage/session_storage.dart';

class SessionManager {
  SessionManager(this._sessionStorage);

  final SessionStorage _sessionStorage;

  Future<void> logout() async {
    await _sessionStorage.clearSession();
  }
}
