import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:kasut/providers/wishlist_provider.dart';
import 'package:kasut/widgets/sneaker_card.dart'; // Import SneakerCard

class WishlistScreen extends StatefulWidget {
  static const String routeName = '/wishlist';

  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadWishlist();
  }

  Future<void> _checkAuthAndLoadWishlist() async {
    setState(() {
      _isLoading = true;
    });

    // Check if user is logged in
    final currentUser = AuthService.currentUser;
    final isLoggedIn = currentUser != null;

    if (isLoggedIn) {
      // Get user ID (using email as ID)
      final userId = currentUser['email']?.toString() ?? '';

      // Initialize wishlist provider with user ID
      await Provider.of<WishlistProvider>(
        context,
        listen: false,
      ).initializeWithUser(userId);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: () {
              // TODO: Implement filter action if needed
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Check if user is logged in
    final isLoggedIn = AuthService.currentUser != null;

    if (!isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please log in to view your wishlist.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName).then((_) {
                  _checkAuthAndLoadWishlist();
                });
              },
              child: const Text('Log In'),
            ),
          ],
        ),
      );
    }

    // Use Consumer to listen to wishlist changes
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final wishlistItems = wishlistProvider.getWishlistItems();

        if (wishlistItems.isEmpty) {
          return const Center(child: Text('Your wishlist is empty.'));
        }

        // Use LayoutBuilder to determine screen size and adjust columns accordingly
        return LayoutBuilder(
          builder: (context, constraints) {
            // Calculate number of columns based on screen width
            // Default to 2 columns for mobile, more for larger screens
            int crossAxisCount = 2; // Default for mobile

            if (constraints.maxWidth > 600) {
              crossAxisCount = 3; // Tablet
            }
            if (constraints.maxWidth > 900) {
              crossAxisCount = 4; // Desktop
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 0.7, // Adjust based on your card dimensions
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final shoe = wishlistItems[index];
                return Stack(
                  children: [
                    // Use the existing SneakerCard widget
                    SneakerCard(
                      sneaker: shoe,
                      // No need to specify width/height as the grid handles sizing
                      onTap: () {
                        // Navigate to product detail page if needed
                      },
                    ),
                    // Add X button overlay for removal
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () {
                          // Remove from wishlist
                          wishlistProvider.toggleWishlist(shoe.sku);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
