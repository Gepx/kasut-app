import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/shoe_model.dart';
import '../providers/wishlist_provider.dart';
import 'image_loader.dart';

class SneakerCard extends StatelessWidget {
  // Changed to StatelessWidget
  final Shoe sneaker;
  final double? width;
  final double? height;
  final Function()? onTap;

  const SneakerCard({
    super.key,
    required this.sneaker,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Get the wishlist provider
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    // Check if this sneaker is in the wishlist
    final isFavorite = wishlistProvider.isInWishlist(sneaker.sku);

    // Currency formatter for IDR
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ',
      decimalDigits: 0,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height ?? 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Favorite Button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: AssetImageLoader(
                      imagePath: sneaker.firstPict,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Favorite Button - Updated to use provider
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        // Toggle wishlist status using provider
                        wishlistProvider.toggleWishlist(sneaker.sku);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                  // Tags (Best Seller, etc)
                  if (sneaker.tags.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getTagColor(sneaker.tags.first),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          sneaker.tags.first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Rest of the product info section remains the same
            Container(
              height: 100, // Reduced height from 125 to 100
              padding: const EdgeInsets.fromLTRB(
                10,
                0,
                10,
                10,
              ), // Reduced horizontal padding from 12 to 10
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand with fire emoji
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          sneaker.brand,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "🔥",
                        style: TextStyle(fontSize: 12),
                      ), // Reduced from 14 to 12
                    ],
                  ),

                  // Product Name
                  Text(
                    sneaker.name, // Changed from widget.sneaker.name
                    style: const TextStyle(
                      fontSize: 12,
                    ), // Reduced from 14 to 12
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Lowest Ask Label
                  const Text(
                    "Lowest Ask",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ), // Reduced from 12 to 10
                  ),

                  // Spacer to push price info to the bottom
                  const Spacer(),

                  // Price Section - Same height regardless of discount
                  SizedBox(
                    height: 36, // Reduced from 40 to 36
                    child:
                        sneaker.discountPrice !=
                                null // Changed from widget.sneaker.discountPrice
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Discounted Price
                                Text(
                                  currencyFormatter.format(
                                    sneaker
                                        .discountPrice, // Changed from widget.sneaker.discountPrice
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14, // Reduced from 15 to 14
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Original Price (strikethrough)
                                Text(
                                  currencyFormatter.format(
                                    sneaker
                                        .price, // Changed from widget.sneaker.price
                                  ),
                                  style: TextStyle(
                                    fontSize: 10, // Reduced from 12 to 10
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              currencyFormatter.format(
                                sneaker.price,
                              ), // Changed from widget.sneaker.price
                              style: const TextStyle(
                                fontSize: 14, // Reduced from 15 to 14
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get color based on tag
  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Best Seller':
        return Colors.orange;
      case 'Most Popular':
        return Colors.red;
      case 'Special Price':
        return Colors.purple;
      case 'Free Delivery':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
