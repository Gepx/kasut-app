import 'package:flutter/material.dart'; // Corrected import
// import 'package:provider/provider.dart'; // Removed Provider for static auth
// import 'package:kasut_app/features/auth/providers/auth_provider.dart'; // Removed AuthNotifier
import 'features/auth/screens/login_screen.dart';
import 'screens/splash_screen.dart';
import 'features/auth/screens/profile_screen.dart'; // Import the new ProfileScreen
import 'features/auth/screens/signup_screen.dart';
import 'features/profile/screens/buying_screen.dart';
import 'features/profile/screens/selling_screen.dart';
import 'features/profile/screens/consignment_screen.dart';
import 'features/profile/screens/kasut_credit_screen.dart';
import 'features/profile/screens/seller_credit_screen.dart';
import 'features/profile/screens/kasut_points_screen.dart';
import 'features/profile/screens/my_voucher_screen.dart';
import 'features/profile/screens/wishlist_screen.dart';
import 'features/profile/screens/invite_friend_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/profile/screens/faq_screen.dart';
import 'package:kasut/features/blog/blog.dart'; // Assuming this path is correct
import 'package:kasut/features/home/home_page.dart'; // Assuming home-page.dart is the main home widget
import 'package:kasut/features/seller/seller.dart'; // Correct path, class is SellerPage

void main() {
  runApp(
    // ChangeNotifierProvider removed for static auth
    const Kasut(),
  );
}

class SplashDemoApp extends StatelessWidget {
  const SplashDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Demo',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class Kasut extends StatelessWidget {
  const Kasut({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Add theme data
        scaffoldBackgroundColor:
            Colors.white, // Set scaffold background to pure white
        appBarTheme: const AppBarTheme(
          // Ensure AppBars are also white by default if needed
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0, // Optional: remove app bar shadow
        ),
        // You can add other theme customizations here if needed
      ),
      initialRoute: SplashScreen.routeName, // Mulai dari SplashScreen
      routes: {
        SplashScreen.routeName: (context) => const SplashScreen(),
        '/main': (context) => const Main(), // Home with bottom nav
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        BuyingScreen.routeName: (context) => const BuyingScreen(),
        SellingScreen.routeName: (context) => const SellingScreen(),
        ConsignmentScreen.routeName: (context) => const ConsignmentScreen(),
        KasutCreditScreen.routeName: (context) => const KasutCreditScreen(),
        SellerCreditScreen.routeName: (context) => const SellerCreditScreen(),
        KasutPointsScreen.routeName: (context) => const KasutPointsScreen(),
        MyVoucherScreen.routeName: (context) => const MyVoucherScreen(),
        WishlistScreen.routeName: (context) => const WishlistScreen(),
        InviteFriendScreen.routeName: (context) => const InviteFriendScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen(),
        FaqScreen.routeName: (context) => const FaqScreen(),
      },
    );
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

// Update the _MainScreenState class
class _MainScreenState extends State<Main> with SingleTickerProviderStateMixin {
  // Added mixin
  int _selectedIndex = 0;
  TabController? _homeTabController; // Added TabController for Home

  // Use a list of _ScreenData objects for navigation screens
  // Note: This list is built *after* _homeTabController is initialized in initState
  List<_ScreenData> get _bottomNavScreens => [
    _ScreenData(
      // Home screen - uses HomePage and HomeAppBar with the controller
      appBar:
          (context) => HomeAppBar(
            tabController: _homeTabController!,
          ), // Assumes HomeAppBar takes TabController
      body:
          (context) => HomePage(
            tabController: _homeTabController!,
          ), // Assumes HomePage takes TabController
      iconData: Icons.home,
      activeIconData: Icons.home_outlined,
      label: 'Home',
    ),
    // ...other screen data items remain unchanged
    _ScreenData(
      appBar:
          (context) =>
              PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
      body: (context) => const Blog(), // Use actual Blog page
      iconData: Icons.article,
      activeIconData: Icons.newspaper_outlined,
      label: 'Blog',
    ),
    _ScreenData(
      appBar: (context) => const _CustomAppBar(title: 'Market'),
      // TODO: Replace with actual Market page widget when available
      body: (context) => const Center(child: Text('Market Page Placeholder')),
      iconData: Icons.search,
      activeIconData: Icons.search_outlined,
      label: 'Market',
    ),
    _ScreenData(
      appBar:
          (context) =>
              PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
      body:
          (context) => const SellerPage(), // Use correct class name: SellerPage
      iconData: Icons.sell,
      activeIconData: Icons.sell_outlined,
      label: 'Selling',
    ),
    _ScreenData(
      appBar: (context) => const _CustomAppBar(title: 'Profile'),
      body: (context) => const ProfileScreen(), // Keep ProfileScreen here
      iconData: Icons.person_rounded,
      activeIconData: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize TabController for Home page (assuming 3 tabs)
    // TODO: Get the correct tab count dynamically if possible
    _homeTabController = TabController(length: 14, vsync: this);
  }

  void _onIconTapped(int index) {
    // No special navigation for index 0 anymore
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _homeTabController?.dispose(); // Dispose the home tab controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Index out-of-bounds check
    if (_selectedIndex < 0 || _selectedIndex >= _bottomNavScreens.length) {
      return const Scaffold(
        body: Center(child: Text('Error: Invalid screen index.')),
      );
    }

    // AppBar is now directly determined by the selected screen's definition
    // Get the current screen data
    final currentScreen = _bottomNavScreens[_selectedIndex];

    return Scaffold(
      // Use the appBar builder from the current screen data
      appBar: currentScreen.appBar(context),
      // Use the body builder from the current screen data
      body: currentScreen.body(context),
      bottomNavigationBar: _CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onIconTapped,
        screens: _bottomNavScreens,
      ),
    );
  }
}
