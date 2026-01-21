import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

/// Enum representing screen size categories
enum ScreenSize {
  mobile,
  tablet,
  desktop,
}

/// Utility class for responsive design
class ResponsiveUtils {
  ResponsiveUtils._();

  /// Get the current screen size category based on width
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return getScreenSizeFromWidth(width);
  }

  /// Get screen size category from width
  static ScreenSize getScreenSizeFromWidth(double width) {
    if (width < AppDimensions.mobileMaxWidth) {
      return ScreenSize.mobile;
    } else if (width < AppDimensions.tabletMaxWidth) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context) == ScreenSize.desktop;
  }

  /// Get appropriate padding based on screen size
  static EdgeInsets getScreenPadding(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(AppDimensions.paddingM);
      case ScreenSize.tablet:
        return const EdgeInsets.all(AppDimensions.paddingL);
      case ScreenSize.desktop:
        return const EdgeInsets.all(AppDimensions.paddingXL);
    }
  }

  /// Get the number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 1;
      case ScreenSize.tablet:
        return 2;
      case ScreenSize.desktop:
        return 3;
    }
  }

  /// Get content max width based on screen size
  static double getContentMaxWidth(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return AppDimensions.contentMaxWidthMobile;
      case ScreenSize.tablet:
        return AppDimensions.contentMaxWidthTablet;
      case ScreenSize.desktop:
        return AppDimensions.contentMaxWidthDesktop;
    }
  }
}
