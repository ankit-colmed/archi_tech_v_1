import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

/// Vertical spacing widgets
class VerticalSpace extends StatelessWidget {
  final double height;

  const VerticalSpace._(this.height, {super.key});

  /// Extra small vertical space (4px)
  const VerticalSpace.xs({Key? key}) : this._(AppDimensions.spacingXS, key: key);

  /// Small vertical space (8px)
  const VerticalSpace.s({Key? key}) : this._(AppDimensions.spacingS, key: key);

  /// Medium vertical space (16px)
  const VerticalSpace.m({Key? key}) : this._(AppDimensions.spacingM, key: key);

  /// Large vertical space (24px)
  const VerticalSpace.l({Key? key}) : this._(AppDimensions.spacingL, key: key);

  /// Extra large vertical space (32px)
  const VerticalSpace.xl({Key? key}) : this._(AppDimensions.spacingXL, key: key);

  /// Extra extra large vertical space (48px)
  const VerticalSpace.xxl({Key? key}) : this._(AppDimensions.spacingXXL, key: key);

  /// Custom vertical space
  const VerticalSpace.custom(double height, {Key? key}) : this._(height, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

/// Horizontal spacing widgets
class HorizontalSpace extends StatelessWidget {
  final double width;

  const HorizontalSpace._(this.width, {super.key});

  /// Extra small horizontal space (4px)
  const HorizontalSpace.xs({Key? key}) : this._(AppDimensions.spacingXS, key: key);

  /// Small horizontal space (8px)
  const HorizontalSpace.s({Key? key}) : this._(AppDimensions.spacingS, key: key);

  /// Medium horizontal space (16px)
  const HorizontalSpace.m({Key? key}) : this._(AppDimensions.spacingM, key: key);

  /// Large horizontal space (24px)
  const HorizontalSpace.l({Key? key}) : this._(AppDimensions.spacingL, key: key);

  /// Extra large horizontal space (32px)
  const HorizontalSpace.xl({Key? key}) : this._(AppDimensions.spacingXL, key: key);

  /// Extra extra large horizontal space (48px)
  const HorizontalSpace.xxl({Key? key}) : this._(AppDimensions.spacingXXL, key: key);

  /// Custom horizontal space
  const HorizontalSpace.custom(double width, {Key? key}) : this._(width, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

/// Padding wrapper widgets
class AppPadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppPadding._({
    required this.child,
    required this.padding,
    super.key,
  });

  /// All sides padding - extra small (4px)
  factory AppPadding.allXs({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.all(AppDimensions.paddingXS),
      key: key,
      child: child,
    );
  }

  /// All sides padding - small (8px)
  factory AppPadding.allS({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.all(AppDimensions.paddingS),
      key: key,
      child: child,
    );
  }

  /// All sides padding - medium (16px)
  factory AppPadding.allM({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      key: key,
      child: child,
    );
  }

  /// All sides padding - large (24px)
  factory AppPadding.allL({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      key: key,
      child: child,
    );
  }

  /// All sides padding - extra large (32px)
  factory AppPadding.allXl({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      key: key,
      child: child,
    );
  }

  /// Horizontal padding - small (8px)
  factory AppPadding.horizontalS({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingS),
      key: key,
      child: child,
    );
  }

  /// Horizontal padding - medium (16px)
  factory AppPadding.horizontalM({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      key: key,
      child: child,
    );
  }

  /// Horizontal padding - large (24px)
  factory AppPadding.horizontalL({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      key: key,
      child: child,
    );
  }

  /// Vertical padding - small (8px)
  factory AppPadding.verticalS({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingS),
      key: key,
      child: child,
    );
  }

  /// Vertical padding - medium (16px)
  factory AppPadding.verticalM({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
      key: key,
      child: child,
    );
  }

  /// Vertical padding - large (24px)
  factory AppPadding.verticalL({required Widget child, Key? key}) {
    return AppPadding._(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
      key: key,
      child: child,
    );
  }

  /// Custom padding
  factory AppPadding.custom({
    required Widget child,
    required EdgeInsetsGeometry padding,
    Key? key,
  }) {
    return AppPadding._(
      padding: padding,
      key: key,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}
