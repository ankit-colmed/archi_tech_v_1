import 'package:flutter/material.dart';
import '../../core/utils/platform_utils.dart';
import '../../core/utils/responsive_utils.dart';

/// A widget that builds different layouts based on screen size and optionally platform.
/// 
/// The layout selection follows this priority:
/// 1. If platform-specific UI is declared, use it
/// 2. Otherwise, fallback to screen size based UI (mobile, tablet, desktop)
class ResponsiveLayoutBuilder extends StatelessWidget {
  /// Required: Mobile layout (used as default fallback)
  final Widget mobile;
  
  /// Optional: Tablet layout (falls back to mobile if not provided)
  final Widget? tablet;
  
  /// Optional: Desktop layout (falls back to tablet, then mobile if not provided)
  final Widget? desktop;

  /// Optional: Platform-specific overrides
  /// These take priority over screen size layouts when provided
  final Widget? android;
  final Widget? ios;
  final Widget? web;
  final Widget? windows;
  final Widget? macos;
  final Widget? linux;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.android,
    this.ios,
    this.web,
    this.windows,
    this.macos,
    this.linux,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // First, check for platform-specific UI
        final platformWidget = _getPlatformSpecificWidget();
        if (platformWidget != null) {
          return platformWidget;
        }

        // Fallback to screen size based UI
        final screenSize = ResponsiveUtils.getScreenSizeFromWidth(constraints.maxWidth);
        return _getScreenSizeWidget(screenSize);
      },
    );
  }

  /// Get platform-specific widget if declared
  Widget? _getPlatformSpecificWidget() {
    final platform = PlatformUtils.currentPlatform;
    
    switch (platform) {
      case AppPlatform.android:
        return android;
      case AppPlatform.ios:
        return ios;
      case AppPlatform.web:
        return web;
      case AppPlatform.windows:
        return windows;
      case AppPlatform.macos:
        return macos;
      case AppPlatform.linux:
        return linux;
      case AppPlatform.unknown:
        return null;
    }
  }

  /// Get widget based on screen size with fallback logic
  Widget _getScreenSizeWidget(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.mobile:
        return mobile;
    }
  }
}

/// Extension to provide responsive value selection
extension ResponsiveExtension on BuildContext {
  /// Select a value based on screen size
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final screenSize = ResponsiveUtils.getScreenSize(this);
    switch (screenSize) {
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.mobile:
        return mobile;
    }
  }

  /// Get current screen size
  ScreenSize get screenSize => ResponsiveUtils.getScreenSize(this);

  /// Check if current screen is mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if current screen is tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if current screen is desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
}
