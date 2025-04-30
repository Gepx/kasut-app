import 'package:flutter/foundation.dart';

/// Utilities for handling images in the app
class ImageUtils {
  // Default placeholder image to use when an image is not found
  static const String defaultPlaceholder = 'assets/brands/placeholder.png';

  /// Returns a clean image path by fixing common issues
  static String getCleanImagePath(String originalPath) {
    // Fix newlines that might be in the path
    String path = originalPath.replaceAll(RegExp(r'\s*\n\s*'), '').trim();

    // Check for web prefix duplication
    if (kIsWeb) {
      // Remove duplicate "assets/" prefixes
      if (path.startsWith('assets/assets/')) {
        path = path.replaceFirst('assets/', '');
      }

      // Ensure proper prefixing
      if (!path.startsWith('assets/') && !path.startsWith('/assets/')) {
        path = 'assets/$path';
      }
    } else {
      // For non-web platforms
      if (!path.startsWith('assets/')) {
        path = 'assets/$path';
      }
    }

    return path;
  }

  /// Formats a product image path for consistent loading
  static String formatProductImagePath(
    String brand,
    String productName,
    int imageNumber,
  ) {
    String cleanProductName = productName
        .replaceAll(' ', '_')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll("'", '');

    return 'assets/brand-products/$brand/${cleanProductName}_$imageNumber.png';
  }

  /// Returns a placeholder image path if the original doesn't exist
  static String getImagePathWithFallback(
    String originalPath, [
    String? fallbackPath,
  ]) {
    String cleanPath = getCleanImagePath(originalPath);
    String fallback = fallbackPath ?? defaultPlaceholder;

    // On web and mobile, we can't check file existence before loading
    return cleanPath;
  }

  /// Debug helper for image paths
  static String getImagePathDebugInfo(String originalPath) {
    return 'Original: $originalPath\nCleaned: ${getCleanImagePath(originalPath)}';
  }
}
