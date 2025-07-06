import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kasut/core/data/brand_loader.dart';
import 'package:kasut/core/navigation/app_bar_factory.dart';
import 'package:kasut/core/navigation/bottom_navigation_bar.dart';
import 'package:kasut/core/navigation/navigation_manager.dart';
import 'package:kasut/features/market/market.dart';
import 'package:kasut/providers/order_provider.dart';
import 'package:kasut/providers/notification_provider.dart';

/// Main container component following micro-frontend architecture
class MainContainer extends StatefulWidget {
  final int initialIndex;

  const MainContainer({super.key, this.initialIndex = 0});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer>
    with TickerProviderStateMixin {
  late final NavigationManager _navigationManager = NavigationManager(
    initialIndex: widget.initialIndex,
    vsync: this,
    marketScreenKey: _marketScreenKey,
  );
  final BrandLoader _brandLoader = BrandLoader();
  final GlobalKey<MarketScreenState> _marketScreenKey =
      GlobalKey<MarketScreenState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupNotificationIntegration();
  }

  Future<void> _initializeData() async {
    // We need a context to load assets, so we wait for the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _brandLoader.loadBrands(context);
      if (mounted) {
        _navigationManager.initializeControllers(_brandLoader.brands);
      }
    });
  }

  void _setupNotificationIntegration() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);
      final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      
      // Set up callback to generate notifications when orders change
      orderProvider.setOrdersChangedCallback((orders) {
        notificationProvider.generateNotificationsFromOrders(orders);
      });
      
      // Generate initial notifications from existing orders
      notificationProvider.generateNotificationsFromOrders(orderProvider.orders);
    });
  }

  @override
  void dispose() {
    _navigationManager.dispose();
    _brandLoader.dispose();
    super.dispose();
  }

  void _onFilterPressed() {
    _marketScreenKey.currentState?.showFilterModal();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _brandLoader,
      builder: (context, child) {
        if (_brandLoader.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        }
        if (_brandLoader.error != null) {
          return Scaffold(
            body: Center(child: Text('Error loading brands: ${_brandLoader.error}')),
          );
        }

        return ListenableBuilder(
          listenable: _navigationManager,
          builder: (context, child) {
            if (!_navigationManager.isInitialized) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator(color: Colors.black)),
              );
            }
            final currentScreen = _navigationManager.currentScreen;

            return Scaffold(
              appBar: AppBarFactory.create(
                screenType: currentScreen.type,
                tabController:
                    _navigationManager.getTabController(currentScreen.type),
                brands: _brandLoader.brands,
                onFilterPressed: _onFilterPressed,
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