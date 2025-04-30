import 'package:flutter/material.dart';

/// A widget that displays a placeholder image when the actual image is not available
class PlaceholderImage extends StatelessWidget {
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String text;

  const PlaceholderImage({
    super.key,
    this.width,
    this.height,
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.borderColor = const Color(0xFFE0E0E0),
    this.textColor = const Color(0xFF757575),
    this.text = 'No Image',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, color: textColor, size: 24),
            const SizedBox(height: 8),
            Text(text, style: TextStyle(color: textColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
