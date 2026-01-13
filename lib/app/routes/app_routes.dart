/// Centralized application route paths.
class AppRoutes {
  const AppRoutes._();

  /// Splash screen route.
  static const String splash = '/splash';

  /// Authentication route.
  static const String auth = '/auth';

  /// Home route.
  static const String home = '/home';

  /// Create session route.
  static const String createSession = '/create-session';

  /// Session result route.
  static const String sessionResult = '/create-session/session-result';

  static const String lecturerCourseView = '/lecturer-course-view';

  /// Scan Attendance route.
  static const String scanAttendance = '/scan-attendance';

  /// Attendance History route.
  static const String attendanceHistory = '/attendance-history';

  /// Enroll course route.
  static const String enrollCourse = '/enroll-course';

  ///Add course route.
  static const String addCourse = '/add-course';

  /// Active sessions route.
  static const String activeSessions = '/active-sessions';

  /// Session details route.
  static const String sessionDetails = '/session-details';

  /// Routes that should bounce authenticated users back to home.
  static const Set<String> authRedirectBlock = {splash, auth};
}
