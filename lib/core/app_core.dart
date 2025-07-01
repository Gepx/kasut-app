import 'package:flutter/material.dart';
import 'package:kasut/screens/splash_screen.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/auth/screens/signup_screen.dart';
import 'package:kasut/features/auth/screens/profile_screen.dart';
import 'package:kasut/features/profile/screens/buying_screen.dart';
import 'package:kasut/features/profile/screens/selling_screen.dart';
import 'package:kasut/features/profile/screens/consignment_screen.dart';
import 'package:kasut/features/profile/screens/kasut_credit_screen.dart';
import 'package:kasut/features/profile/screens/seller_credit_screen.dart';
import 'package:kasut/features/profile/screens/kasut_points_screen.dart';
import 'package:kasut/features/profile/screens/my_voucher_screen.dart';
import 'package:kasut/features/profile/screens/wishlist_screen.dart';
import 'package:kasut/features/profile/screens/invite_friend_screen.dart';
import 'package:kasut/features/profile/screens/settings_screen.dart';
import 'package:kasut/features/profile/screens/faq_screen.dart';

/// Core application module containing theme and routing configuration
class AppCore {
  /// Application theme
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
  );

  /// Application routes
  static Map<String, WidgetBuilder> get routes => {
    SplashScreen.routeName: (context) => const SplashScreen(),
    '/home': (context) => const MainRefactored(),
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
  };
}

/// Forward declaration for MainRefactored - will be defined in main.dart
class MainRefactored extends StatefulWidget {
  final int initialIndex;

  const MainRefactored({super.key, this.initialIndex = 0});

  @override
  State<MainRefactored> createState() => _MainRefactoredState();
}

class _MainRefactoredState extends State<MainRefactored> {
  @override
  Widget build(BuildContext context) {
    // This will be implemented in main.dart
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 