<h1 align="center">
  <img src="assets/icons/app_logo.png" alt="Examify Logo" width="120">
  <br>
  Raqeeb 📚
</h1>

<p align="center">
  <strong>A comprehensive standard-driven Flutter Application for Seamless Examination and Grading</strong>
</p>

<p align="center">
  <i>Faculty of Computers and Artificial Intelligence (FCAI) — Capstone Project</i>
</p>

---

## 🌟 Overview

**Raqeeb** is a robust, cross-platform mobile application designed to streamline the examination process for both **Students** and **Instructors**. Built as a university capstone project, Examify bridges the gap between educational assessments and modern user experiences, providing a seamless, secure, and intuitive environment for academic testing.

Built with **Flutter**, the system adheres to strict **Clean Architecture** patterns, leveraging **BLoC/Cubit** for reactive state management, and **Retrofit/Dio** for type-safe sophisticated REST API integration. 

---

## ✨ Features

### 🎓 For Students
- **Real-Time Exams:** Join active exam sessions instantaneously, supported by a slick, responsive UI.
- **Academic Dashboard & History:** View detailed exam histories, upcoming test schedules, and real-time results.
- **Comprehensive Statistics:** Rich statistical visualization of overall performance, grading progress, integrity alerts, and time metrics.
- **Secure Authentication:** JWT-based persistent sessions using secure storage and automated refresh token cycles.
- **Profile Management:** Fully interactive profile dashboard, including secure password changes and strict account deletion flows.
- **Local Reminders & Notifications:** Native system local notifications scheduled specifically to remind students 10 minutes prior to and explicitly at the start of any upcoming exam.

### 👨‍🏫 For Instructors
- **Instructor Statistics Dashboard:** Monitor live analytical breakdowns of system-wide average scores, student performances, and real-time exam tracking using `fl_chart`.
- **Advanced Exam Management:** Create, deploy, and review active or completed examinations seamlessly, complete with an intuitive unified exam creation flow and inline question editing.
- **Automated Results:** Automatically compute scores and easily generate/print PDF reports directly from the app.

---

## 🛠️ Technology Stack

Examify is built utilizing the best modern standards in the Flutter ecosystem:

- **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.10.3)
- **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Cubit Pattern)
- **Networking:** [Dio](https://pub.dev/packages/dio) & [Retrofit](https://pub.dev/packages/retrofit) (Type-safe HTTP) 
- **Data Models:** [Freezed](https://pub.dev/packages/freezed) & [json_serializable](https://pub.dev/packages/json_serializable)
- **Local Storage:** [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) & Shared Preferences
- **UI & Animations:** [Skeletonizer](https://pub.dev/packages/skeletonizer) (Loading states), [Toastification](https://pub.dev/packages/toastification) (Snackbars), [ScreenUtil](https://pub.dev/packages/flutter_screenutil) (Responsiveness)
- **Testing & Tooling:** [Device Preview](https://pub.dev/packages/device_preview) for responsive interface testing.
- **Notifications:** [Firebase Cloud Messaging (FCM)](https://pub.dev/packages/firebase_messaging), combined with [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) and [flutter_timezone](https://pub.dev/packages/flutter_timezone) for precise local scheduling.
- **Visuals:** [FL Chart](https://pub.dev/packages/fl_chart), [PDF](https://pub.dev/packages/pdf), [Printing](https://pub.dev/packages/printing)

---

## 📁 Project Architecture

The architecture maintains a clean separation of concerns, broken primarily by `features` and foundational `core` systems.

```text
lib/
├── core/                   # Application-wide foundational logic
│   ├── config/             # Environment configs (dev, staging, prod)
│   ├── networking/         # Dio interceptors, ApiService, Error Models
│   ├── routing/            # Centralized AppRouter
│   ├── services/           # Notification services, timezone scheduling
│   ├── storage/            # SecureStorage & SharedPreferences logic
│   ├── themes/             # Color tokens, typographies, AppColors
│   └── widgets/            # Reusable generic UI hooks (CustomTextField, CustomButton)
└── features/               # Modular features
    ├── auth/               # Login, Sign Up, Onboarding
    ├── instructor/         # Instructor Dashboard, Statistics, Exam generation
    ├── shared/             # Reusable domain Logic (Profile)
    └── student/            # Student UI, Exam Joining, Stats, History
```

Within each feature folder, we adhere strictly to:
- `data/` (models, repositories, DTOs)
- `logic/` (Cubit, state management)
- `ui/` (screens, widgets)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK installed (preferably stable channel > 3.10)
- IDE setup (VS Code or Android Studio) with dart-code plugin

### Installation & Run

1. **Clone the repository** and fetch packages:
   ```bash
   flutter pub get
   ```

2. **Run Code Generation:**
   Because this project heavily leverages `freezed` and `retrofit`, you must generate the `.g.dart` data classes before compiling the app:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Environment Setup:**
   The `ApiConstants.apiBaseUrl` calculates the target server based on compile-time environment flags. 
   
   To run in **Development** mode (Localhost API):
   ```bash
   flutter run --dart-define=APP_ENV=dev
   ```
   To run targeting the **Staging / Production** remote server API:
   ```bash
   flutter run --dart-define=APP_ENV=staging
   ```

---

## ⚙️ Backend Integration Checklist 

The application is inherently wired to scale alongside the remote .NET/Node backend. 

- [x] **Authentication Flow:** Login, Registration, Auto-Login (Persisted JWT).
- [x] **Refresh Cycle:** Secure token revocation and refreshing.
- [x] **Profile API:** Fetch user profile, Change Password, and Account Deletion endpoints.
- [x] **Instructor APIs:** Fetch created exams, advanced unified exam creation, question editing, and aggregated dashboard dashboard statistics (`/api/instructors/me/statistics`).
- [x] **Student APIs:** Join sessions via ID, query active upcoming exams, check historical completions, and fetch personalized analytics (`/api/students/me/statistics`).
- [x] **State Interceptors:** Invalidation of expired sessions automatically navigating bounds to the `LoginScreen`.
- [x] **Notification Scheduling:** Foreground/background scheduling based on explicit local times matching server timestamps.
- [ ] **Forgot Password API:** Integrate recovery mail endpoints.

---

*Designed and developed for the FCAI Capstone Project — 2026.*
