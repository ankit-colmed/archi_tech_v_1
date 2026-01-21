import 'dart:io';
import 'package:flutter/foundation.dart';

/// Enum representing supported platforms
enum AppPlatform {
  android,
  ios,
  web,
  windows,
  macos,
  linux,
  unknown,
}

/// Utility class for platform detection
class PlatformUtils {
  PlatformUtils._();

  /// Get the current platform
  static AppPlatform get currentPlatform {
    if (kIsWeb) return AppPlatform.web;
    
    if (Platform.isAndroid) return AppPlatform.android;
    if (Platform.isIOS) return AppPlatform.ios;
    if (Platform.isWindows) return AppPlatform.windows;
    if (Platform.isMacOS) return AppPlatform.macos;
    if (Platform.isLinux) return AppPlatform.linux;
    
    return AppPlatform.unknown;
  }

  /// Check if current platform is mobile
  static bool get isMobile {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if current platform is desktop
  static bool get isDesktop {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Check if current platform is web
  static bool get isWeb => kIsWeb;

  /// Check if current platform is Android
  static bool get isAndroid {
    if (kIsWeb) return false;
    return Platform.isAndroid;
  }

  /// Check if current platform is iOS
  static bool get isIOS {
    if (kIsWeb) return false;
    return Platform.isIOS;
  }

  /// Check if current platform is Windows
  static bool get isWindows {
    if (kIsWeb) return false;
    return Platform.isWindows;
  }

  /// Check if current platform is macOS
  static bool get isMacOS {
    if (kIsWeb) return false;
    return Platform.isMacOS;
  }

  /// Check if current platform is Linux
  static bool get isLinux {
    if (kIsWeb) return false;
    return Platform.isLinux;
  }
}
