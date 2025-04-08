import 'package:flutter/material.dart';
import 'package:tugasuts/features/blog/blog.dart';
import 'package:tugasuts/features/home/home_page.dart';
import 'package:tugasuts/features/seller/seller.dart';

void main() {
  runApp(const Kasut());
}

class Kasut extends StatelessWidget {
  const Kasut({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: const Main());
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainScreenState();
}

// Data class to represent screen information
class _ScreenData {
  final PreferredSizeWidget Function(BuildContext) appBar;
  final WidgetBuilder body;
  final IconData iconData;
  final IconData activeIconData;
  final String label;

  const _ScreenData({
    required this.appBar,
    required this.body,
    required this.iconData,
    required this.activeIconData,
    required this.label,
  });
}

// Custom AppBar to avoid code duplication
class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const _CustomAppBar({required this.title});

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

// Extracted BottomNavigationBar as a separate widget
class _CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_ScreenData> screens;
  static const double _bottomNavBarHeight = 70;

  const _CustomBottomNavigationBar({
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
        items:
            screens
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

class _MainScreenState extends State<Main> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  // Use a list of _ScreenData objects instead of Maps
  final List<_ScreenData> _bottomNavScreens = [
    _ScreenData(
      appBar: (context) => const HomeAppBar(),
      body: (context) => const HomeBody(),
      iconData: Icons.home,
      activeIconData: Icons.home_outlined,
      label: 'Home',
    ),
    _ScreenData(
      appBar:
          (context) =>
              PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
      body: (context) => const Blog(),
      iconData: Icons.article,
      activeIconData: Icons.newspaper_outlined,
      label: 'Blog',
    ),
    _ScreenData(
      appBar: (context) => const _CustomAppBar(title: 'Market'),
      body: (context) => const Center(child: Text('Market Content')),
      iconData: Icons.search,
      activeIconData: Icons.search_outlined,
      label: 'Market',
    ),
    _ScreenData(
      appBar:
          (context) =>
              PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
      body: (context) => const SellerPage(),
      iconData: Icons.sell,
      activeIconData: Icons.sell_outlined,
      label: 'Selling',
    ),
    _ScreenData(
      appBar: (context) => const _CustomAppBar(title: 'Profile'),
      body: (context) => const Center(child: Text('Profile Content')),
      iconData: Icons.person_rounded,
      activeIconData: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the TabController here, using 'this' for vsync
    _tabController = TabController(length: 10, vsync: this);
  }

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Index out-of-bounds check (defensive programming)
    if (_selectedIndex < 0 || _selectedIndex >= _bottomNavScreens.length) {
      return const Scaffold(
        body: Center(child: Text('Error: Invalid screen index.')),
      );
    }

    return Scaffold(
      body: HomeStateProvider(
        tabController: _tabController,
        child: Scaffold(
          appBar: _bottomNavScreens[_selectedIndex].appBar(context),
          body: _bottomNavScreens[_selectedIndex].body(context),
          bottomNavigationBar: _CustomBottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onIconTapped,
            screens: _bottomNavScreens,
          ),
        ),
      ),
    );
  }
}
