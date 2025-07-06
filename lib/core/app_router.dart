import 'package:flutter/material.dart';
import 'package:kasut/screens/splash_screen.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/auth/screens/signup_screen.dart';
import 'package:kasut/features/auth/screens/profile_screen.dart';
import 'package:kasut/features/profile/screens/buying_screen.dart';
import 'package:kasut/features/profile/screens/selling_screen.dart';
import 'package:kasut/features/profile/screens/kasut_credit_screen.dart';
import 'package:kasut/features/profile/screens/seller_credit_screen.dart';
import 'package:kasut/features/profile/screens/kasut_points_screen.dart';
import 'package:kasut/features/profile/screens/my_voucher_screen.dart';
import 'package:kasut/features/profile/screens/wishlist_screen.dart';
import 'package:kasut/features/profile/screens/invite_friend_screen.dart';
import 'package:kasut/features/profile/screens/settings_screen.dart';
import 'package:kasut/features/profile/screens/faq_screen.dart';
import 'package:kasut/features/profile/screens/edit_profile_screen.dart';
import 'package:kasut/core/main_navigation.dart';

/// Centralized application router following micro-frontend architecture
class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String buying = '/buying';
  static const String selling = '/selling';
  static const String kasutCredit = '/kasut-credit';
  static const String sellerCredit = '/seller-credit';
  static const String kasutPoints = '/kasut-points';
  static const String myVoucher = '/my-voucher';
  static const String wishlist = '/wishlist';
  static const String inviteFriend = '/invite-friend';
  static const String settings = '/settings';
  static const String faq = '/faq';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    home: (context) => const MainNavigation(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    buying: (context) => const BuyingScreen(),
    selling: (context) => const SellingScreen(),
    kasutCredit: (context) => const KasutCreditScreen(),
    sellerCredit: (context) => const SellerCreditScreen(),
    kasutPoints: (context) => const KasutPointsScreen(),
    myVoucher: (context) => const MyVoucherScreen(),
    wishlist: (context) => const WishlistScreen(),
    inviteFriend: (context) => const InviteFriendScreen(),
    settings: (context) => const SettingsScreen(),
    faq: (context) => const FaqScreen(),
  };

  static String get initialRoute => splash;

  /// Navigate to a specific route
  static void navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  /// Navigate and replace current route
  static void navigateToReplace(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  /// Navigate and clear all previous routes
  static void navigateToAndClearAll(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
} 