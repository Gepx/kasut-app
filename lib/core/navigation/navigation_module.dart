import 'package:flutter/material.dart';
import 'package:kasut/features/home/home_page.dart';
import 'package:kasut/features/blog/blog.dart';
import 'package:kasut/features/market/market.dart';
import 'package:kasut/features/seller/seller.dart';
import 'package:kasut/features/auth/screens/profile_screen.dart';

/// Navigation module following micro-frontend architecture
class NavigationModule extends ChangeNotifier {
  final TickerProvider _vsync;
  int _selectedIndex = 0;
  TabController? _homeTabController;
  TabController? _marketTabController;
  List<String> _brands = [];

  NavigationModule({
    required TickerProvider vsync,
    int initialIndex = 0,
  }) : _vsync = vsync,
       _selectedIndex = initialIndex;

  int get selectedIndex => _selectedIndex;

  /// Initialize tab controllers after brands are loaded
  void initialize(List<String> brands) {
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

  /// Handle tab tap
  void onTabTapped(int index) {
    if (index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// Build app bar based on current screen
  PreferredSizeWidget? buildAppBar(List<String> brands) {
    switch (_selectedIndex) {
      case 0: // Home
        if (_homeTabController != null) {
          return HomeAppBar(
            tabController: _homeTabController!,
            brands: brands,
          );
        }
        break;
      case 2: // Market
        if (_marketTabController != null) {
          return MarketAppBar(
            tabController: _marketTabController!,
            brands: brands,
          );
        }
        break;
      default:
        return const PreferredSize(
          preferredSize: Size.zero,
          child: SizedBox.shrink(),
        );
    }
    return null;
  }

  /// Build body based on current screen
  Widget buildBody(List<String> brands) {
    switch (_selectedIndex) {
      case 0: // Home
        return _homeTabController != null
            ? HomePage(
                tabController: _homeTabController!,
                brands: brands,
              )
            : const Center(child: CircularProgressIndicator());
      case 1: // Blog
        return const Blog();
      case 2: // Market
        return _marketTabController != null
            ? MarketScreen(
                tabController: _marketTabController!,
                brands: brands,
              )
            : const Center(child: CircularProgressIndicator());
      case 3: // Seller
        return const SellerPage();
      case 4: // Profile
        return const ProfileScreen();
      default:
        return const Center(child: Text('Invalid screen'));
    }
  }

  /// Build bottom navigation bar
  Widget buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(color: Colors.white),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        iconSize: 24,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Selling',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(color: Colors.black, size: 26),
        unselectedIconTheme: const IconThemeData(color: Colors.black, size: 24),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        onTap: onTabTapped,
      ),
    );
  }

  @override
  void dispose() {
    _homeTabController?.dispose();
    _marketTabController?.dispose();
    super.dispose();
  }
} 