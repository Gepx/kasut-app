import 'package:flutter/material.dart';
import 'package:kasut/core/navigation/navigation_manager.dart';
import 'package:kasut/core/navigation/bottom_navigation_bar.dart';
import 'package:kasut/core/navigation/app_bar_factory.dart';
import 'package:kasut/core/data/brand_loader.dart';

/// Main navigation container following micro-frontend architecture
class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> 
    with TickerProviderStateMixin {
  late final NavigationManager _navigationManager;
  late final BrandLoader _brandLoader;
  
  @override
  void initState() {
    super.initState();
    _navigationManager = NavigationManager(
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _brandLoader = BrandLoader();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _brandLoader.loadBrands(context);
    _navigationManager.initializeControllers(_brandLoader.brands);
  }

  @override
  void dispose() {
    _navigationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _brandLoader,
      builder: (context, child) {
        if (_brandLoader.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return ListenableBuilder(
          listenable: _navigationManager,
          builder: (context, child) {
            final currentScreen = _navigationManager.currentScreen;
            
            return Scaffold(
              appBar: AppBarFactory.create(
                screenType: currentScreen.type,
                tabController: _navigationManager.getTabController(
                  currentScreen.type,
                ),
                brands: _brandLoader.brands,
              ),
              body: currentScreen.body(context),
              bottomNavigationBar: KasutBottomNavigationBar(
                currentIndex: _navigationManager.selectedIndex,
                onTap: _navigationManager.onTabTapped,
                screens: _navigationManager.screens,
              ),
            );
          },
        );
      },
    );
  }
} 