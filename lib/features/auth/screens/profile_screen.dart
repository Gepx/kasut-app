import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:tugasuts/features/auth/providers/auth_provider.dart'; // Import AuthNotifier
import 'package:tugasuts/features/auth/screens/login_screen.dart'; // Import LoginScreen
import 'package:tugasuts/features/auth/screens/register_screen.dart'; // Import RegisterScreen

// Profile Screen now uses AuthNotifier for state
class ProfileScreen extends StatelessWidget { // Changed to StatelessWidget
  const ProfileScreen({super.key});

  // Removed _ProfileScreenState class

  // Placeholder methods for navigation (now accept BuildContext)
  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _navigateToRegister(BuildContext context) {
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Consume the AuthNotifier
    final authNotifier = Provider.of<AuthNotifier>(context);

    // Use the AppBar provided by main.dart via the _ScreenData setup
    // The Scaffold is also managed by main.dart's structure for screens in the bottom nav
    return authNotifier.isLoggedIn
        ? _buildLoggedInView(context, authNotifier) // Pass notifier to logged-in view
        : _buildLoggedOutView(context);
  }

  // --- Logged Out View ---
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
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Description Text
          Text(
            'Get the most out of the Kick Avenue app by creating or signing in to your account.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Login/Register Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center buttons in the row
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
                   child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
                 ),
              ),
              const SizedBox(width: 16), // Spacing between buttons

              // Register Button
               ConstrainedBox(
                 constraints: const BoxConstraints(minWidth: buttonMinWidth),
                 child: ElevatedButton(
                   onPressed: () => _navigateToRegister(context), // Pass context
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.black,
                     foregroundColor: Colors.white,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(8),
                     ),
                      minimumSize: const Size(0, buttonHeight), // Set height
                   ),
                   child: const Text('Register', style: TextStyle(fontWeight: FontWeight.bold)),
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

  // --- Logged In View ---
  Widget _buildLoggedInView(BuildContext context, AuthNotifier authNotifier) { // Accept AuthNotifier
    final textTheme = Theme.of(context).textTheme;

    // TODO: Replace with actual user data
    const String username = 'vale6502 -';
    const String email = 'valentinolubu2@gmail.com';
    const String kickCredit = 'IDR 0';
    const String sellerCredit = 'IDR 0';
    const String kickPoints = 'KP 0';


    return ListView( // Use ListView for scrollability
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Add vertical padding
      children: [
        // User Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person_outline, size: 30, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(email, style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Credit Cards Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildCreditCard( // Pass context
                  context: context,
                  icon: Icons.account_balance_wallet_outlined, // Placeholder icon
                  iconColor: Colors.green.shade300,
                  title: 'Kick Credit',
                  value: kickCredit,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCreditCard( // Pass context
                  context: context,
                  icon: Icons.sell_outlined, // Placeholder icon
                  iconColor: Colors.red.shade300,
                  title: 'Seller Credit',
                  value: sellerCredit,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Kick Points Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildCreditCard( // Pass context
            context: context,
            icon: Icons.star_border_outlined, // Placeholder icon
            iconColor: Colors.blue.shade300,
            title: 'Kick Points',
            value: kickPoints,
            isFullWidth: true,
          ),
        ),
        const SizedBox(height: 16),

        const Divider(height: 1, thickness: 1),

        // Menu List
        _buildMenuItem(context: context, icon: Icons.shopping_bag_outlined, title: 'Buying'), // Pass context
        _buildMenuItem(context: context, icon: Icons.storefront_outlined, title: 'Selling'), // Pass context
        _buildMenuItem(context: context, icon: Icons.inventory_2_outlined, title: 'Consignment'), // Pass context
        _buildMenuItem(context: context, icon: Icons.local_offer_outlined, title: 'My Voucher'), // Pass context
        _buildMenuItem(context: context, icon: Icons.favorite_border_outlined, title: 'Wishlist'), // Pass context

        const Divider(height: 1, thickness: 1), // Add divider at the end too
         const SizedBox(height: 20),

         // Logout Button
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
           child: ElevatedButton(
             onPressed: () {
               authNotifier.logout(); // Call logout on the notifier
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.redAccent, // Distinct color for logout
               foregroundColor: Colors.white,
               minimumSize: const Size(double.infinity, 50), // Full width
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
               ),
             ),
             child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
           ),
         ),
          const SizedBox(height: 20), // Bottom padding
     ],
   );
  }

  // Helper Widget for Credit/Points Cards
  Widget _buildCreditCard({
    required BuildContext context, // Accept context
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    bool isFullWidth = false,
  }) {
    return Container(
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
      child: Row( // Use Row for Kick Points card as well
        mainAxisAlignment: isFullWidth ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 8),
                  Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                ],
              ),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          if (isFullWidth) // Only show arrow for Kick Points
             Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
        ],
      ),
    );
  }


  // Helper Widget for Menu Items
  Widget _buildMenuItem({required BuildContext context, required IconData icon, required String title}) { // Accept context
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: () {
        // TODO: Implement navigation or action for menu item 'title'
        print('Tapped on $title');
      },
    );
  }
}