import 'package:flutter/material.dart';

/// Disables the overscroll "glow" effect that appears on scrollable widgets
/// by returning the child widget directly without any decoration.
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
} 