import 'package:flutter/material.dart';

/// Types of screens in the navigation
enum ScreenType {
  home,
  blog,
  market,
  seller,
  profile,
}

/// Data class to represent screen information in micro-frontend architecture
class ScreenData {
  final ScreenType type;
  final WidgetBuilder body;
  final IconData iconData;
  final IconData activeIconData;
  final String label;

  const ScreenData({
    required this.type,
    required this.body,
    required this.iconData,
    required this.activeIconData,
    required this.label,
  });

  /// Factory methods for each screen type
  static ScreenData home(WidgetBuilder body) => ScreenData(
    type: ScreenType.home,
    body: body,
    iconData: Icons.home,
    activeIconData: Icons.home_outlined,
    label: 'Home',
  );

  static ScreenData blog(WidgetBuilder body) => ScreenData(
    type: ScreenType.blog,
    body: body,
    iconData: Icons.article,
    activeIconData: Icons.newspaper_outlined,
    label: 'Blog',
  );

  static ScreenData market(WidgetBuilder body) => ScreenData(
    type: ScreenType.market,
    body: body,
    iconData: Icons.search,
    activeIconData: Icons.search_outlined,
    label: 'Market',
  );

  static ScreenData seller(WidgetBuilder body) => ScreenData(
    type: ScreenType.seller,
    body: body,
    iconData: Icons.sell,
    activeIconData: Icons.sell_outlined,
    label: 'Selling',
  );

  static ScreenData profile(WidgetBuilder body) => ScreenData(
    type: ScreenType.profile,
    body: body,
    iconData: Icons.person_rounded,
    activeIconData: Icons.person_outline,
    label: 'Profile',
  );

  /// Check if this screen type requires a tab controller
  bool get requiresTabController => 
      type == ScreenType.home || type == ScreenType.market;

  /// Check if this screen type should show app bar
  bool get showsAppBar => 
      type == ScreenType.home || type == ScreenType.market;
} 