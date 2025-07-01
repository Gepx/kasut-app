import 'package:flutter/material.dart';
import 'package:kasut/core/navigation/screen_data.dart';
import 'package:kasut/features/home/home_page.dart';
import 'package:kasut/features/market/market.dart';

/// Factory for creating appropriate app bars for different screen types
class AppBarFactory {
  /// Create app bar based on screen type
  static PreferredSizeWidget? create({
    required ScreenType screenType,
    TabController? tabController,
    List<String>? brands,
  }) {
    switch (screenType) {
      case ScreenType.home:
        if (tabController != null && brands != null) {
          return HomeAppBar(
            tabController: tabController,
            brands: brands,
          );
        }
        return null;
        
      case ScreenType.market:
        if (tabController != null && brands != null) {
          return MarketAppBar(
            tabController: tabController,
            brands: brands,
          );
        }
        return null;
        
      case ScreenType.blog:
      case ScreenType.seller:
      case ScreenType.profile:
        return const PreferredSize(
          preferredSize: Size.zero,
          child: SizedBox.shrink(),
        );
    }
  }

  /// Create a simple app bar with title
  static PreferredSizeWidget createSimple({
    required String title,
    List<Widget>? actions,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      actions: actions,
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }

  /// Create an empty app bar (no visible app bar)
  static PreferredSizeWidget createEmpty() {
    return const PreferredSize(
      preferredSize: Size.zero,
      child: SizedBox.shrink(),
    );
  }
} 