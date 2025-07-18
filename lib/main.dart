import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kasut/core/app_core.dart';
import 'package:kasut/core/components/main_container.dart';
import 'package:kasut/providers/wishlist_provider.dart';
import 'package:kasut/providers/order_provider.dart';
import 'package:kasut/providers/seller_provider.dart';
import 'package:kasut/providers/credit_provider.dart';
import 'package:kasut/providers/notification_provider.dart';
import 'package:kasut/providers/profile_provider.dart';
import 'package:kasut/providers/voucher_provider.dart';
import 'package:kasut/utils/no_glow_scroll_behavior.dart';

void main() {
  // Keep default (hash) web URL strategy for stability in dev server.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => SellerProvider()),
        ChangeNotifierProvider(create: (context) => KasutCreditProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => VoucherProvider()),
        ChangeNotifierProvider(
          create: (_) => KasutPointsProvider(),
        ), // Add this back
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => SellerProvider()),
        ChangeNotifierProvider(create: (context) => KasutCreditProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => VoucherProvider()),
      ],
      child: MaterialApp(
        title: 'Kasut App',
        theme: AppCore.theme,
        scrollBehavior: NoGlowScrollBehavior(),
        routes: AppCore.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Main application widget
class MainRefactored extends StatefulWidget {
  final int initialIndex;

  const MainRefactored({super.key, this.initialIndex = 0});

  @override
  State<MainRefactored> createState() => _MainRefactoredState();
}

class _MainRefactoredState extends State<MainRefactored> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(initialIndex: widget.initialIndex);
  }
}
