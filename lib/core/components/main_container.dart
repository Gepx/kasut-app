import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:kasut/features/market/market.dart';
import 'package:kasut/features/blog/blog.dart';
import 'package:kasut/features/home/home_page.dart';
import 'package:kasut/features/seller/seller.dart';
import 'package:kasut/features/auth/screens/profile_screen.dart';

/// Screen data model for micro-frontend approach
class ScreenData {
  final PreferredSizeWidget Function(BuildContext) appBar;
  final WidgetBuilder body;
  final IconData iconData;
  final IconData activeIconData;
  final String label;

  const ScreenData({
    required this.appBar,
    required this.body,
    required this.iconData,
    required this.activeIconData,
    required this.label,
  });
}

/// Custom AppBar component
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ''),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Custom Bottom Navigation Bar component
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<ScreenData> screens;
  static const double _bottomNavBarHeight = 70;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.screens,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _bottomNavBarHeight,
      decoration: const BoxDecoration(color: Colors.white),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        iconSize: 24,
        backgroundColor: Colors.white,
        items: screens
            .map(
              (screen) => BottomNavigationBarItem(
                icon: Icon(
                  currentIndex == screens.indexOf(screen)
                      ? screen.iconData
                      : screen.activeIconData,
                ),
                label: screen.label,
              ),
            )
            .toList(),
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
        onTap: onTap,
      ),
    );
  }
}

/// Brand loader service component
class BrandLoaderService {
  static Future<List<String>> loadBrands(BuildContext context) async {
    try {
      final manifestContent = await DefaultAssetBundle.of(context)
          .loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final Set<String> brandNames = {};

      manifestMap.keys
          .where((String key) {
            return key.startsWith('assets/brand-products/') &&
                !key.endsWith('/');
          })
          .forEach((String key) {
            final parts = key.split('/');
            if (parts.length > 2) {
              brandNames.add(parts[2]);
            }
          });

      return ["All", ...brandNames];
    } catch (e) {
      print('Error loading brands: $e');
      return ["All", "Error Loading Brands"];
    }
  }
}

/// Main container component following micro-frontend architecture
class MainContainer extends StatefulWidget {
  final int initialIndex;

  const MainContainer({super.key, this.initialIndex = 0});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  TabController? _homeTabController;
  TabController? _marketTabController;
  List<String> _brands = [];
  bool _isLoadingBrands = true;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    final brands = await BrandLoaderService.loadBrands(context);
    setState(() {
      _brands = brands;
      _isLoadingBrands = false;
      _homeTabController = TabController(length: _brands.length, vsync: this);
      _marketTabController = TabController(length: _brands.length, vsync: this);

      _homeTabController!.addListener(() => setState(() {}));
      _marketTabController!.addListener(() => setState(() {}));
    });
  }

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFilterPressed() {
    // TODO: Implement filter functionality for market screen
    // This could show a filter modal or navigate to a filter screen
    print('Filter button pressed');
  }

  List<ScreenData> get _bottomNavScreens => [
    ScreenData(
      appBar: (context) => HomeAppBar(
        tabController: _homeTabController!,
        brands: _brands,
      ),
      body: (context) => HomePage(
        tabController: _homeTabController!,
        brands: _brands,
      ),
      iconData: Icons.home,
      activeIconData: Icons.home_outlined,
      label: 'Home',
    ),
    ScreenData(
      appBar: (context) => const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox.shrink(),
      ),
      body: (context) => const Blog(),
      iconData: Icons.article,
      activeIconData: Icons.newspaper_outlined,
      label: 'Blog',
    ),
    ScreenData(
      appBar: (context) => MarketAppBar(
        tabController: _marketTabController!,
        brands: _brands,
        onFilterPressed: _onFilterPressed,
      ),
      body: (context) => MarketScreen(
        tabController: _marketTabController!,
        brands: _brands,
        standalone: false,
      ),
      iconData: Icons.search,
      activeIconData: Icons.search_outlined,
      label: 'Market',
    ),
    ScreenData(
      appBar: (context) => const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox.shrink(),
      ),
      body: (context) => const SellerPage(),
      iconData: Icons.sell,
      activeIconData: Icons.sell_outlined,
      label: 'Selling',
    ),
    ScreenData(
      appBar: (context) => const PreferredSize(
        preferredSize: Size.zero,
        child: SizedBox.shrink(),
      ),
      body: (context) => const ProfileScreen(),
      iconData: Icons.person_rounded,
      activeIconData: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  void dispose() {
    _homeTabController?.dispose();
    _marketTabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingBrands) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_selectedIndex < 0 || _selectedIndex >= _bottomNavScreens.length) {
      return const Scaffold(
        body: Center(child: Text('Error: Invalid screen index.')),
      );
    }

    final currentScreen = _bottomNavScreens[_selectedIndex];

    return Scaffold(
      appBar: currentScreen.appBar(context),
      body: currentScreen.body(context),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onIconTapped,
        screens: _bottomNavScreens,
      ),
    );
  }
} 