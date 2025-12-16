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

  /// Routes that should bounce authenticated users back to home.
  static const Set<String> authRedirectBlock = {splash, auth};
}
