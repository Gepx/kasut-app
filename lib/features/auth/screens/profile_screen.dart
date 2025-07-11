import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Import iconsax
import 'package:provider/provider.dart'; // Add this import
import 'package:kasut/providers/wishlist_provider.dart'; // Add this import
import 'package:kasut/providers/profile_provider.dart';
import 'package:kasut/providers/credit_provider.dart';
import 'package:kasut/providers/seller_provider.dart'; // Added for SellerCredit
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/profile/screens/buying_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/selling_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/kasut_credit_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/seller_credit_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/kasut_points_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/my_voucher_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/wishlist_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/addresses_screen.dart';
import 'package:kasut/features/profile/screens/payment_methods_screen.dart';
import 'package:kasut/features/profile/screens/invite_friend_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/settings_screen.dart'; // Placeholder
import 'package:kasut/features/profile/screens/faq_screen.dart'; // Placeholder
import 'signup_screen.dart'; // Use relative import for SignupScreen
import 'dart:io'; // Added for File

// Profile Screen now uses AuthService for state
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  void _navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, SignupScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Use ProfileProvider for profile data
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final hasProfile = profileProvider.username.isNotEmpty;
        return Scaffold(
          body:
              hasProfile
                  ? _buildLoggedInView(context, profileProvider)
                  : _buildLoggedOutView(context),
        );
      },
    );
  }

  // --- Logged Out View (Keep existing implementation) ---
  Widget _buildLoggedOutView(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const double buttonHeight = 50.0;
    const double buttonMinWidth = 150.0; // Ensure buttons have enough width

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stacked Avatar Placeholder
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.grey[300], // Lighter grey
              ),
              Positioned(
                top: 30, // Adjust position slightly down
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[600], // Darker grey
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Greeting Text
          Text(
            'Hi, Fam!',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description Text
          Text(
            'Get the most out of the Kasut app by creating or signing in to your account.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Login/Register Buttons
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center buttons in the row
            children: [
              // Login Button
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: buttonMinWidth),
                child: OutlinedButton(
                  onPressed: () => _navigateToLogin(context), // Pass context
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, buttonHeight), // Set height
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Spacing between buttons
              // Register Button
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: buttonMinWidth),
                child: ElevatedButton(
                  onPressed:
                      () => _navigateToSignup(context), // Use updated method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(0, buttonHeight), // Set height
                  ),
                  child: const Text(
                    'Sign Up', // Changed text
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Version Text
          Text(
            'Version 5.0.13', // Match version from image
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50), // Add some bottom padding if needed
        ],
      ),
    );
  }

  // --- Logged In View (Updated Implementation) ---
  Widget _buildLoggedInView(
    BuildContext context,
    ProfileProvider profileProvider,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final String username = profileProvider.username;
    final String? profileImagePath = profileProvider.profileImagePath;
    const String kasutCredit = 'IDR 0';
    const String sellerCredit = 'IDR 0';
    const String kasutPoints = 'KP 0';
    const String version = 'Version 5.0.13';

    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // --- Top User Info Section ---
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  backgroundImage:
                      profileImagePath != null && profileImagePath.isNotEmpty
                          ? FileImage(File(profileImagePath))
                          : null,
                  child:
                      profileImagePath == null || profileImagePath.isEmpty
                          ? const Icon(
                            Iconsax.user,
                            color: Colors.white,
                            size: 30,
                          )
                          : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Space between sections
          // --- Credit/Points Section ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCreditCard(
                        context: context,
                        icon: Iconsax.wallet_3, // Wallet icon
                        iconColor: Colors.orange, // Example color
                        title: 'Kasut Credit',
                        valueWidget: Consumer<KasutCreditProvider>(
                          builder: (context, creditProvider, _) {
                            return Text(
                              'IDR ${creditProvider.balance.toStringAsFixed(0)}',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        routeName:
                            KasutCreditScreen.routeName, // Navigation route
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCreditCard(
                        context: context,
                        icon: Iconsax.money_recive, // Money receive icon
                        iconColor: Colors.green, // Example color
                        title: 'Seller Credit',
                        valueWidget: Consumer<SellerProvider>(
                          builder: (context, sellerProvider, _) {
                            final sellerCredit =
                                sellerProvider.profile != null &&
                                        sellerProvider.profile!['credit'] !=
                                            null
                                    ? sellerProvider.profile!['credit']
                                    : 0;
                            return Text(
                              'IDR ${sellerCredit.toString()}',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        routeName:
                            SellerCreditScreen.routeName, // Navigation route
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildCreditCard(
                  context: context,
                  icon: Iconsax.star1, // Star icon
                  iconColor: Colors.blue, // Example color
                  title: 'Kasut Points',
                  valueWidget: Consumer<KasutPointsProvider>(
                    builder: (context, pointsProvider, _) {
                      return Text(
                        'KP ${pointsProvider.points.toString()}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  isFullWidth: true,
                  routeName: KasutPointsScreen.routeName, // Navigation route
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Space between sections
          // --- Menu List Section 1 ---
          _buildMenuSection([
            _buildMenuItem(
              context: context,
              icon: Iconsax.shopping_bag,
              title: 'Buying',
              routeName: BuyingScreen.routeName,
            ),
            _buildMenuItem(
              context: context,
              icon: Iconsax.shop,
              title: 'Selling',
              routeName: SellingScreen.routeName,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressesScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            color: Colors.black87,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'My Addresses',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 0.5, indent: 56),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PaymentMethodsScreen(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Icon(Iconsax.card, color: Colors.black87, size: 24),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Payment Methods',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 0.5, indent: 56),
                  ],
                ),
              ),
            ),
            _buildMenuItem(
              context: context,
              icon: Iconsax.ticket_discount,
              title: 'My Voucher',
              routeName: MyVoucherScreen.routeName,
            ),
            _buildMenuItem(
              context: context,
              icon: Iconsax.heart,
              title: 'Wishlist',
              routeName: WishlistScreen.routeName,
              showDivider:
                  false, // No divider after the last item in this section
            ),
          ]),
          const SizedBox(height: 10), // Space between sections
          // --- Menu List Section 2 ---
          _buildMenuSection([
            _buildMenuItem(
              context: context,
              icon: Iconsax.user_add,
              title: 'Invite a Friend',
              routeName: InviteFriendScreen.routeName,
            ),
            _buildMenuItem(
              context: context,
              icon: Iconsax.setting_2,
              title: 'Settings',
              routeName: SettingsScreen.routeName,
              showDivider:
                  false, // No divider after the last item in this section
            ),
          ]),
          const SizedBox(height: 10), // Space between sections
          // --- Help Center Section ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help Center',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildHelpContactItem(
                  context,
                  Iconsax.sms,
                  'Email',
                  'info@kasut.com',
                ),
                _buildHelpContactItem(
                  context,
                  Iconsax.message,
                  'WhatsApp',
                  '+62 123 4567 890',
                ), // Placeholder number
                _buildHelpContactItem(
                  context,
                  Iconsax.instagram,
                  'Instagram',
                  '@kasut.app',
                ),
                _buildHelpContactItem(
                  context,
                  Iconsax.link, // Replaced facebook icon with link
                  'Facebook',
                  'Kasut App',
                ), // Placeholder name
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FaqScreen.routeName);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('FAQ'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10), // Space between sections
          // --- Logout Button ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: _buildMenuItem(
              context: context,
              icon: Iconsax.logout,
              title: 'Logout',
              isLogout: true, // Special flag for logout action
              showDivider: false,
              color: Colors.red, // Red color for logout
            ),
          ),
          const SizedBox(height: 20), // Space at the bottom
          // --- Version ---
          Text(
            version,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 30), // Bottom padding
        ],
      ),
    );
  }

  // Helper Widget for Menu Sections (groups items with background and padding)
  Widget _buildMenuSection(List<Widget> items) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(
        horizontal: 0,
      ), // No horizontal margin needed if items handle padding
      child: Column(children: items),
    );
  }

  // Helper Widget for Credit/Points Cards (Updated)
  Widget _buildCreditCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget valueWidget, // Changed from String value
    bool isFullWidth = false,
    required String routeName, // Added routeName for navigation
  }) {
    return GestureDetector(
      // Make the card tappable
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: iconColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                valueWidget, // Use the new valueWidget
              ],
            ),
            Icon(
              // Always show arrow now
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Menu Items (Updated)
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? routeName, // Optional route name
    bool isLogout = false, // Flag for logout action
    bool showDivider = true, // Control divider visibility
    Color? color, // Optional color for icon and text
  }) {
    return InkWell(
      // Use InkWell for tap feedback
      onTap: () {
        // In the _buildMenuItem method where isLogout is true
        if (isLogout) {
          // Clear the wishlist first
          Provider.of<WishlistProvider>(context, listen: false).clearWishlist();
          // Then logout
          AuthService.logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        } else if (routeName != null) {
          Navigator.pushNamed(context, routeName);
        } else {
          print('Tapped on $title - No route defined');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ), // Padding inside InkWell
        child: Column(
          children: [
            Padding(
              // Padding for the ListTile content
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
              ), // Vertical padding for item height
              child: Row(
                children: [
                  Icon(icon, color: color ?? Colors.black87, size: 24), // Icon
                  const SizedBox(width: 16), // Space between icon and title
                  Expanded(
                    // Title takes remaining space
                    child: Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: color),
                    ),
                  ),
                  if (!isLogout) // Don't show arrow for logout
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade400,
                    ), // Trailing arrow
                ],
              ),
            ),
            if (showDivider)
              const Divider(
                height: 1,
                thickness: 0.5,
                indent: 56,
              ), // Divider with indent
          ],
        ),
      ),
    );
  }

  // Helper Widget for Help Center Contact Items
  Widget _buildHelpContactItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
