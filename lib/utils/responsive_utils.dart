import 'package:flutter/widgets.dart';

/// Mobile-first responsive utility for Indonesian Kasut app
class ResponsiveUtils {
  // Mobile-first breakpoints for Indonesian market
  static const double smallMobile = 375;  // iPhone SE, Android small
  static const double mobile = 414;       // iPhone 11 Pro, most Android
  static const double largeMobile = 480;  // Large phones
  static const double tablet = 768;       // iPad mini, Android tablets

  /// Get device type based on width
  static DeviceType getDeviceType(double width) {
    if (width < mobile) return DeviceType.smallMobile;
    if (width < largeMobile) return DeviceType.mobile;
    if (width < tablet) return DeviceType.largeMobile;
    return DeviceType.tablet;
  }

  /// Get optimal grid columns for mobile-first design
  static int getProductGridColumns(double width) {
    if (width < mobile) return 2;        // Small phones: 2 columns
    if (width < largeMobile) return 2;   // Regular phones: 2 columns  
    if (width < tablet) return 2;        // Large phones: 2 columns
    return 3;                            // Tablets: 3 columns
  }

  /// Get category grid columns (more items per row)
  static int getCategoryGridColumns(double width) {
    if (width < mobile) return 4;        // Small phones: 4 columns
    if (width < largeMobile) return 4;   // Regular phones: 4 columns
    if (width < tablet) return 4;        // Large phones: 4 columns  
    return 6;                            // Tablets: 6 columns
  }

  /// Get mobile-optimized padding
  static EdgeInsets getResponsivePadding(double width) {
    if (width < mobile) {
      return const EdgeInsets.all(12);   // Tight spacing for small screens
    } else if (width < tablet) {
      return const EdgeInsets.all(16);   // Standard mobile padding
    } else {
      return const EdgeInsets.all(24);   // More space for tablets
    }
  }

  /// Get product card aspect ratio optimized for mobile
  static double getProductCardAspectRatio(double width) {
    // Consistent aspect ratio for mobile viewing
    return 0.75; // 3:4 ratio works well for product cards on mobile
  }

  /// Get touch-friendly button height
  static double getButtonHeight(double width) {
    return 48.0; // Minimum 44px for accessibility, 48px for comfort
  }

  /// Get mobile-optimized spacing
  static double getSpacing(double width, SpacingSize size) {
    switch (size) {
      case SpacingSize.xs:
        return width < mobile ? 4 : 6;
      case SpacingSize.sm:
        return width < mobile ? 8 : 12;
      case SpacingSize.md:
        return width < mobile ? 12 : 16;
      case SpacingSize.lg:
        return width < mobile ? 16 : 24;
      case SpacingSize.xl:
        return width < mobile ? 24 : 32;
    }
  }

  /// Check device types
  static bool isSmallMobile(double width) => width < mobile;
  static bool isMobile(double width) => width < tablet;
  static bool isTablet(double width) => width >= tablet;

  /// Get safe area padding for different devices
  static EdgeInsets getSafeAreaPadding(double width) {
    return EdgeInsets.only(
      top: isSmallMobile(width) ? 8 : 12,
      bottom: isSmallMobile(width) ? 8 : 12,
    );
  }
}

enum DeviceType {
  smallMobile,  // < 414px
  mobile,       // 414px - 480px  
  largeMobile,  // 480px - 768px
  tablet,       // >= 768px
}

enum SpacingSize {
  xs, sm, md, lg, xl
}

/// Mobile-first responsive builder widget
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType, double width) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final deviceType = ResponsiveUtils.getDeviceType(width);
        return builder(context, deviceType, width);
      },
    );
  }
} 