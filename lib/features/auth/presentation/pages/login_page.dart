import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/responsive_layout_builder.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

/// Login page with responsive and platform-specific UI
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          // Navigate to home on successful login
          context.goToHome();
        } else if (state.hasError && state.errorMessage != null) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          // Clear error state
          context.read<AuthBloc>().add(const AuthErrorCleared());
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ResponsiveLayoutBuilder(
            // Mobile layout
            mobile: const _MobileLoginLayout(),
            // Tablet layout
            tablet: const _TabletLoginLayout(),
            // Desktop layout
            desktop: const _DesktopLoginLayout(),
            // Platform-specific: iOS gets a different style
            ios: const _IOSLoginLayout(),
            // Platform-specific: Android uses material design
            android: const _AndroidLoginLayout(),
          ),
        ),
      ),
    );
  }
}

/// Mobile login layout
class _MobileLoginLayout extends StatelessWidget {
  const _MobileLoginLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacingXXL),
          _buildHeader(),
          const SizedBox(height: AppDimensions.spacingXXL),
          const LoginForm(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          child: const Icon(
            Icons.health_and_safety,
            size: 48,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: AppDimensions.fontHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        const Text(
          AppStrings.loginToContinue,
          style: TextStyle(
            fontSize: AppDimensions.fontL,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Tablet login layout
class _TabletLoginLayout extends StatelessWidget {
  const _TabletLoginLayout();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(AppDimensions.paddingXL),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: AppDimensions.spacingXL),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          ),
          child: const Icon(
            Icons.health_and_safety,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        const Text(
          AppStrings.welcomeBack,
          style: TextStyle(
            fontSize: AppDimensions.fontHeading,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        const Text(
          AppStrings.loginToContinue,
          style: TextStyle(
            fontSize: AppDimensions.fontL,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Desktop login layout with side image
class _DesktopLoginLayout extends StatelessWidget {
  const _DesktopLoginLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left side - Branding
        Expanded(
          flex: 5,
          child: Container(
            color: AppColors.primary,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.health_and_safety,
                  size: 120,
                  color: Colors.white,
                ),
                const SizedBox(height: AppDimensions.spacingL),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  AppStrings.appTagline,
                  style: TextStyle(
                    fontSize: AppDimensions.fontXL,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right side - Login form
        Expanded(
          flex: 4,
          child: Container(
            color: AppColors.surface,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingXL),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        AppStrings.welcomeBack,
                        style: TextStyle(
                          fontSize: AppDimensions.fontHeading,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingS),
                      const Text(
                        AppStrings.loginToContinue,
                        style: TextStyle(
                          fontSize: AppDimensions.fontL,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),
                      const LoginForm(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// iOS-specific login layout with Cupertino styling
class _IOSLoginLayout extends StatelessWidget {
  const _IOSLoginLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingXL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacingXL),
          // iOS style header with SF Symbol-like icon
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withBlue(255),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          const Center(
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXS),
          Center(
            child: Text(
              AppStrings.loginToContinue,
              style: TextStyle(
                fontSize: AppDimensions.fontL,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          const LoginForm(isIOSStyle: true),
        ],
      ),
    );
  }
}

/// Android-specific login layout with Material Design
class _AndroidLoginLayout extends StatelessWidget {
  const _AndroidLoginLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppDimensions.spacingXXL),
          // Material Design header
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.local_hospital,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          const Center(
            child: Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: AppDimensions.fontHeading,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          const Center(
            child: Text(
              AppStrings.loginToContinue,
              style: TextStyle(
                fontSize: AppDimensions.fontL,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingXXL),
          const LoginForm(),
        ],
      ),
    );
  }
}
