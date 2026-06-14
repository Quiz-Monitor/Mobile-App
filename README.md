 # Examify

## Backend Integration Preparation (Pre-endpoint phase)

This project is prepared to run safely before backend endpoints are ready.

### Environment configuration

`ApiConstants.apiBaseUrl` is selected by compile-time env:

- `APP_ENV=dev` (default) → `http://10.0.2.2:7158/`
- `APP_ENV=staging` → `https://staging-api.examify.com/`
- `APP_ENV=prod` → `https://api.examify.com/`

### Mock mode (opt-in)

The app uses real backend endpoints by default.

- Flag: `USE_MOCK_API`
- Default: `false`

Examples:

- Run with mock mode:
	- `flutter run --dart-define=USE_MOCK_API=true --dart-define=APP_ENV=dev`
- Run against real backend later:
	- `flutter run --dart-define=USE_MOCK_API=false --dart-define=APP_ENV=staging`

### Code generation commands

- `flutter pub get`
- `dart run build_runner build --delete-conflicting-outputs`

### Implemented readiness scaffolding

- Auth request/response contracts (`login`, `signup`) with nullable-safe helpers.
- Centralized API endpoint constants + placeholders.
- Session storage scaffold (`SessionStorage`) with in-memory implementation.
- Dio interceptor hooks for auth header + future token refresh handling.
- Repository mock branches with stable `ApiResult` contract.
- Login flow guarded by Cubit state (no direct bypass navigation).
- Starter repository stubs for student/instructor modules.

### Backend handoff package (single source of truth)

#### Endpoint list (current + placeholders)
- `api/auth/login` (Integrated)
- `api/auth/register` (Integrated)
- `api/auth/refresh` (Integrated)
- `api/auth/logout` (Integrated)
- `api/auth/change-password` (Integrated)
- `api/auth/delete-account` (Integrated)
- `api/users/me` (Integrated - User Profile)
- `api/exams/join` (Integrated - Student Join)
- `api/students/me/exams` (Integrated - Student Upcoming Exams)
- `api/students/me/results` (Integrated - Student Exam History)
- `api/exams` (Integrated - Instructor Exams)
- `api/auth/forgot-password` (placeholder)
- `api/notifications` (placeholder)

#### Request/response JSON examples

Login request:
```json
{ "email": "student@examify.test", "password": "123456" }
```

Login response (expected):
```json
{
	"token": "access_token",
	"refreshToken": "refresh_token",
	"expiresAt": "2026-12-31T23:59:59Z",
	"message": "Login successful",
	"user": {
		"userId": 1,
		"email": "student@examify.test",
		"fullName": "Student Name",
		"role": "Student",
		"phoneNumber": "01000000000"
	}
}
```

Signup request:
```json
{
	"fullName": "Student Name",
	"email": "student@examify.test",
	"password": "123456",
	"role": "Student",
	"phoneNumber": "01000000000"
}
```

#### Error schema expected by app
```json
{
	"message": "Validation failed",
	"code": 400,
	"status": 400,
	"title": "Bad Request",
	"errors": {
		"email": ["Email is invalid"]
	}
}
```

#### Auth token expectations
- Access token in `token` field.
- Refresh token in `refreshToken` field.
- Bearer token attached by interceptor when available.

### Integration checklist

- [x] Replace mock branches with real API calls for Auths, Profile, Exams.
- [x] Account Deletion and Change Password implementations.
- [x] Add refresh-token endpoint and retry flow.
- [x] Replace in-memory session storage with secure storage.
- [ ] Wire forgot-password call in `ApiService` and repo.
- [ ] Add/enable repository + cubit + widget tests for real API scenarios.
