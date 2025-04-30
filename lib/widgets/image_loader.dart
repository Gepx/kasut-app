import 'package:flutter/material.dart';
import 'placeholder_image.dart';

/// A widget for loading asset images with robust error handling
class AssetImageLoader extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? fallbackImagePath;

  const AssetImageLoader({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.fallbackImagePath,
  });

  @override
  Widget build(BuildContext context) {
    // Remove 'assets/' prefix if it exists and add it back properly
    String cleanPath = imagePath;
    if (cleanPath.contains('assets/assets/')) {
      cleanPath = cleanPath.replaceFirst('assets/assets/', 'assets/');
    } else if (!cleanPath.startsWith('assets/')) {
      cleanPath = 'assets/$cleanPath';
    }

    // Clean up newlines and spaces
    cleanPath = cleanPath.replaceAll(RegExp(r'\s*\n\s*'), '').trim();

    return Image.asset(
      cleanPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        // Log the error for debugging
        print('Error loading image: $cleanPath - $error');

        // Try fallback image if provided
        if (fallbackImagePath != null) {
          return Image.asset(
            fallbackImagePath!,
            fit: fit,
            width: width,
            height: height,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          );
        }

        return _buildPlaceholder();
      },
    );
  }

  // Use our PlaceholderImage widget
  Widget _buildPlaceholder() {
    return PlaceholderImage(width: width, height: height, text: 'No image');
  }
}
