/// Centralized string constants for the application
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'ArchiTech';
  static const String appTagline = 'Healthcare Platform';

  // Auth Strings
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String emailHint = 'Enter your email';
  static const String passwordHint = 'Enter your password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signUp = 'Sign Up';
  static const String welcomeBack = 'Welcome Back';
  static const String loginToContinue = 'Login to continue';
  static const String loginSuccess = 'Login successful!';
  static const String loginFailed = 'Login failed. Please try again.';

  // Validation Messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort = 'Password must be at least 6 characters';

  // Home Screen
  static const String home = 'Home';
  static const String patients = 'Patients';
  static const String patientList = 'Patient List';
  static const String noPatients = 'No patients found';
  static const String refresh = 'Refresh';
  static const String retry = 'Retry';

  // Patient Card
  static const String patientId = 'Patient ID';
  static const String mobile = 'Mobile';
  static const String avgScore = 'Avg Score';
  static const String createdDate = 'Created Date';
  static const String result = 'Result';
  static const String notAvailable = 'N/A';

  // Error Messages
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternet = 'No internet connection';
  static const String serverError = 'Server error. Please try again later.';
  static const String sessionExpired = 'Session expired. Please login again.';
  static const String loadingFromCache = 'Loading from offline cache';

  // Loading States
  static const String loading = 'Loading...';
  static const String pleaseWait = 'Please wait...';

  // Actions
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String view = 'View';
  static const String search = 'Search';
}
