import 'package:flutter/material.dart'; // Corrected import
import 'dart:convert'; // Import dart:convert for json decoding
import 'package:kasut/features/market/market.dart';
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
import 'package:kasut/features/seller/sellerlogic.dart';
import 'package:kasut/features/seller/seller_service.dart';
import 'package:url_strategy/url_strategy.dart'; // Import for URL strategy

void main() {
  // Remove hash from URLs
  setPathUrlStrategy();
  runApp(const Kasut());
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
        '/home': (context) => const Main(), // Changed from '/main' to '/home'
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
  // Optional initial tab index for bottom navigation
  final int initialIndex;

  const Main({super.key, this.initialIndex = 0});

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
class _MainScreenState extends State<Main> with TickerProviderStateMixin {
  late int _selectedIndex;
  TabController? _homeTabController;
  TabController? _marketTabController;

  List<String> _brands = []; // State variable to hold brands
  bool _isLoadingBrands = true; // State variable to track loading

  // Use a list of _ScreenData objects for navigation screens
  List<_ScreenData> get _bottomNavScreens => [
    _ScreenData(
      // Home screen - uses HomePage and HomeAppBar with the controller
      appBar:
          (context) => HomeAppBar(
            tabController: _homeTabController!,
            brands: _brands, // Pass brands to HomeAppBar
          ),
      body:
          (context) => HomePage(
            tabController: _homeTabController!,
            brands: _brands, // Pass brands to HomePage
          ),
      iconData: Icons.home,
      activeIconData: Icons.home_outlined,
      label: 'Home',
    ),
    _ScreenData(
      appBar:
          (context) => const PreferredSize(
            preferredSize: Size.zero,
            child: SizedBox.shrink(),
          ),
      body: (context) => const Blog(), // Use actual Blog page
      iconData: Icons.article,
      activeIconData: Icons.newspaper_outlined,
      label: 'Blog',
    ),
    _ScreenData(
      appBar:
          (context) => MarketAppBar(
            tabController: _marketTabController!,
            brands: _brands, // Pass brands to MarketAppBar
          ),
      body:
          (context) => MarketScreen(
            // Wrap MarketScreen in a WidgetBuilder
            tabController: _marketTabController!,
            brands: _brands, // Pass brands to MarketScreen
          ),
      iconData: Icons.search,
      activeIconData: Icons.search_outlined,
      label: 'Market',
    ),
    _ScreenData(
      appBar:
          (context) =>
              PreferredSize(preferredSize: Size.zero, child: SizedBox.shrink()),
      body:
          (context) =>
              // Show registration form if not yet registered, else show seller products
              SellerService.currentSeller == null
                  ? SellerPage()
                  : SellerLogic(),
      iconData: Icons.sell,
      activeIconData: Icons.sell_outlined,
      label: 'Selling',
    ),
    _ScreenData(
      appBar:
          (context) => const PreferredSize(
            preferredSize: Size.zero,
            child: SizedBox.shrink(),
          ),
      body: (context) => const ProfileScreen(), // Keep ProfileScreen here
      iconData: Icons.person_rounded,
      activeIconData: Icons.person_outline,
      label: 'Profile',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Set initial selected tab based on widget parameter
    _selectedIndex = widget.initialIndex;

    // Initialize home tab controller with the correct number of tabs (matching brands)
    _homeTabController = TabController(length: 14, vsync: this);
    _homeTabController!.addListener(() {
      // This ensures tab selection is maintained across rebuilds
      setState(() {});
    });

    // Market tab controller
    _marketTabController = TabController(length: 14, vsync: this);
    _marketTabController!.addListener(() {
      setState(() {});
    });
  }

  void _onIconTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
      bottomNavigationBar: _CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onIconTapped,
        screens: _bottomNavScreens,
      ),
    );
  }
}
