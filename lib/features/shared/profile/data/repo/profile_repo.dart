import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:examify/features/shared/profile/data/models/profile_user.dart';

class ProfileRepo {
  final ApiService _apiService;
  final SessionStorage _sessionStorage;

  ProfileRepo(this._apiService, this._sessionStorage);

  Future<ApiResult<ProfileUser>> getProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      final userMap = _extractUserMap(response);

      final cachedFullName = await _sessionStorage.getFullName();
      final cachedEmail = await _sessionStorage.getEmail();
      final cachedRole = await _sessionStorage.getRole();
      final cachedUserId = await _sessionStorage.getUserId();

      final fullName =
          _stringOrNull(userMap['fullName']) ??
          cachedFullName ??
          'Unknown User';
      final email = _stringOrNull(userMap['email']) ?? cachedEmail ?? '-';
      final roleLabel = _normalizeRole(
        _stringOrNull(userMap['role']) ?? cachedRole,
      );
      final phoneNumber =
          _stringOrNull(userMap['phoneNumber']) ??
          _stringOrNull(userMap['phone']) ??
          'Not provided';

      final userIdValue = userMap['userId'] ?? userMap['id'];
      final userIdInt = _intOrNull(userIdValue) ?? cachedUserId;
      final userId = userIdInt?.toString() ?? '-';

      await _sessionStorage.saveSession(
        role: roleLabel,
        userId: userIdInt,
        fullName: fullName,
        email: email,
      );

      return ApiResult.success(
        ProfileUser(
          fullName: fullName,
          email: email,
          roleLabel: roleLabel,
          userId: userId,
          phoneNumber: phoneNumber,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Map<String, dynamic> _extractUserMap(dynamic response) {
    final dynamic nested = response['user'] ?? response['data'] ?? response;

    if (nested is Map<String, dynamic>) {
      return nested;
    }
    if (nested is Map) {
      return nested.cast<String, dynamic>();
    }

    return response;
  }

  String? _stringOrNull(dynamic value) {
    if (value == null) {
      return null;
    }
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  int? _intOrNull(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
  }

  String _normalizeRole(String? role) {
    final roleValue = role?.trim();
    if (roleValue == null || roleValue.isEmpty) {
      return 'User';
    }

    final lower = roleValue.toLowerCase();
    if (lower == 'student') {
      return 'Student';
    }
    if (lower == 'instructor' || lower == 'teacher') {
      return 'Instructor';
    }

    return roleValue;
  }
}
