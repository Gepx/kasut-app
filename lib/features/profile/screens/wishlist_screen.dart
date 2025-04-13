import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Assuming iconsax is used

class WishlistScreen extends StatelessWidget {
  static const String routeName = '/wishlist'; // Define route name

  const WishlistScreen({super.key});

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
            icon: const Icon(Iconsax.filter), // Filter icon
            onPressed: () {
              // TODO: Implement filter action
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Example Wishlist Item Card (Static Data)
          _WishlistItemCard(
            imageUrl: 'https://via.placeholder.com/150', // Placeholder image
            name: 'Nike Air Jordan 1 Retro High OG SP',
            variant: 'Fragment x Travis Scott',
            size: 'US 9.5',
            lowestAsk: 'Rp 25.000.000',
            highestBid: 'Rp 22.500.000',
          ),
          // Add more static items here if needed
        ],
      ),
    );
  }
}

// Helper widget for the wishlist item card
class _WishlistItemCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String variant;
  final String size;
  final String lowestAsk;
  final String highestBid;

  const _WishlistItemCard({
    required this.imageUrl,
    required this.name,
    required this.variant,
    required this.size,
    required this.lowestAsk,
    required this.highestBid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              // Add error builder for network image
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    variant,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text('Size: $size', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lowest Ask',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            lowestAsk,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ), // Or your app's ask color
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Highest Bid',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            highestBid,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ), // Or your app's bid color
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Optional: Add a remove from wishlist button if shown in design
            // IconButton(
            //   icon: Icon(Iconsax.heart_slash), // Or appropriate icon
            //   onPressed: () { /* TODO: Implement remove */ },
            //   padding: EdgeInsets.zero,
            //   constraints: BoxConstraints(),
            // ),
          ],
        ),
      ),
    );
  }
}
