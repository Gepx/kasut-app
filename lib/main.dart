import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:kasut/providers/wishlist_provider.dart';
import 'package:kasut/providers/order_provider.dart';
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
import 'package:kasut/core/components/main_container.dart';

void main() {
  // Remove hash from URLs
  setPathUrlStrategy();
  runApp(const Kasut());
}

/// Splash demo application (micro-frontend module)
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

/// Main application following micro-frontend architecture
class Kasut extends StatelessWidget {
  const Kasut({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          '/home': (context) => const MainContainer(),
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
      ),
    );
  }
}

/// Main class alias for backward compatibility
typedef Main = MainContainer; 