import 'package:flutter/material.dart';
import 'package:kasut/core/navigation/screen_data.dart';
import 'package:kasut/features/home/home_page.dart';
import 'package:kasut/features/blog/blog.dart';
import 'package:kasut/features/market/market.dart';
import 'package:kasut/features/seller/seller.dart';
import 'package:kasut/features/auth/screens/profile_screen.dart';

/// Manages navigation state and tab controllers for micro-frontend architecture
class NavigationManager extends ChangeNotifier {
  final TickerProvider _vsync;
  int _selectedIndex = 0;
  TabController? _homeTabController;
  TabController? _marketTabController;
  List<String> _brands = [];

  NavigationManager({
    required TickerProvider vsync,
    int initialIndex = 0,
  }) : _vsync = vsync,
       _selectedIndex = initialIndex;

  int get selectedIndex => _selectedIndex;
  List<String> get brands => _brands;

  /// Initialize tab controllers after brands are loaded
  void initializeControllers(List<String> brands) {
    _brands = brands;
    
    // Dispose existing controllers
    _homeTabController?.dispose();
    _marketTabController?.dispose();
    
    // Create new controllers
    _homeTabController = TabController(length: _brands.length, vsync: _vsync);
    _marketTabController = TabController(length: _brands.length, vsync: _vsync);
    
    // Add listeners
    _homeTabController!.addListener(() => notifyListeners());
    _marketTabController!.addListener(() => notifyListeners());
    
    notifyListeners();
  }

  /// Get the appropriate tab controller for a screen type
  TabController? getTabController(ScreenType screenType) {
    switch (screenType) {
      case ScreenType.home:
        return _homeTabController;
      case ScreenType.market:
        return _marketTabController;
      default:
        return null;
    }
  }

  /// Get all navigation screens
  List<ScreenData> get screens => [
    ScreenData.home((context) => HomePage(
      tabController: _homeTabController!,
      brands: _brands,
    )),
    ScreenData.blog((context) => const Blog()),
    ScreenData.market((context) => MarketScreen(
      tabController: _marketTabController!,
      brands: _brands,
    )),
    ScreenData.seller((context) => const SellerPage()),
    ScreenData.profile((context) => const ProfileScreen()),
  ];

  /// Get current screen data
  ScreenData get currentScreen {
    if (_selectedIndex < 0 || _selectedIndex >= screens.length) {
      return screens[0]; // Default to home
    }
    return screens[_selectedIndex];
  }

  /// Handle tab tap
  void onTabTapped(int index) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// Navigate to specific screen by type
  void navigateToScreen(ScreenType screenType) {
    final index = screens.indexWhere((screen) => screen.type == screenType);
    if (index != -1) {
      onTabTapped(index);
    }
  }

  /// Check if controllers are initialized
  bool get isInitialized => 
      _homeTabController != null && _marketTabController != null;

  @override
  void dispose() {
    _homeTabController?.dispose();
    _marketTabController?.dispose();
    super.dispose();
  }
} 