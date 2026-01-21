import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/patients/presentation/pages/home_page.dart';

/// Route paths as type-safe constants
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String patientDetails = '/patient/:id';

  // Helper method to build patient details route
  static String patientDetailsPath(int id) => '/patient/$id';
}

/// App Router configuration using go_router
class AppRouter {
  AppRouter._();

  // Navigator key for accessing navigator state
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    routes: [
      // Login Route
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),

      // Home Route
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),

      // Patient Details Route (placeholder for future implementation)
      GoRoute(
        path: AppRoutes.patientDetails,
        name: 'patientDetails',
        pageBuilder: (context, state) {
          final patientId = state.pathParameters['id'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: Scaffold(
              appBar: AppBar(title: Text('Patient $patientId')),
              body: Center(child: Text('Patient Details: $patientId')),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          );
        },
      ),
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.uri.path}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),

    // Redirect logic
    redirect: (context, state) {
      // Add authentication redirect logic here if needed
      // final isLoggedIn = // check auth state
      // final isLoggingIn = state.matchedLocation == AppRoutes.login;

      // if (!isLoggedIn && !isLoggingIn) {
      //   return AppRoutes.login;
      // }

      // if (isLoggedIn && isLoggingIn) {
      //   return AppRoutes.home;
      // }

      return null;
    },
  );
}

/// Navigation extension for type-safe navigation
extension NavigationExtension on BuildContext {
  /// Navigate to login page
  void goToLogin() => go(AppRoutes.login);

  /// Navigate to home page
  void goToHome() => go(AppRoutes.home);

  /// Navigate to patient details
  void goToPatientDetails(int patientId) =>
      go(AppRoutes.patientDetailsPath(patientId));

  /// Push to patient details (allows back navigation)
  void pushPatientDetails(int patientId) =>
      push(AppRoutes.patientDetailsPath(patientId));

  /// Pop current page
  void goBack() => pop();

  /// Check if can pop
  bool get canGoBack => canPop();
}
