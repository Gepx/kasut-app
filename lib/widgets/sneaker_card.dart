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
        height: height ?? 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Product Image Section
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey.shade50,
                      Colors.white,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Stack(
                  children: [
                    // Centered Product Image with better positioning
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.1, // Slight rotation for dynamic look
                            child: AssetImageLoader(
                              imagePath: sneaker.firstPict,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Enhanced Favorite Button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Toggle wishlist status using provider
                            wishlistProvider.toggleWishlist(sneaker.sku);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red.shade600 : Colors.grey.shade600,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Enhanced Tags
                    if (sneaker.tags.isNotEmpty)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getTagColor(sneaker.tags.first),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: _getTagColor(sneaker.tags.first).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            sneaker.tags.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Enhanced Product Info Section
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand with enhanced styling
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sneaker.brand,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                              letterSpacing: 0.2,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "🔥",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Product Name with better styling - more space allocated
                    Expanded(
                      child: Text(
                        sneaker.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(height: 2),

                    // Lowest Ask Label with subtle styling
                    Text(
                      "Lowest Ask",
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Enhanced Price Section
                    sneaker.discountPrice != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Discounted Price
                              Text(
                                currencyFormatter.format(sneaker.discountPrice),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.green.shade700,
                                  height: 1.1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Original Price (strikethrough)
                              Text(
                                currencyFormatter.format(sneaker.price),
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.grey.shade400,
                                  height: 1.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          )
                        : Text(
                            currencyFormatter.format(sneaker.price),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.grey.shade800,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced color scheme for tags
  Color _getTagColor(String tag) {
    switch (tag) {
      case 'Best Seller':
        return Colors.orange.shade600;
      case 'Most Popular':
        return Colors.red.shade600;
      case 'Special Price':
        return Colors.purple.shade600;
      case 'Free Delivery':
        return Colors.green.shade600;
      case 'Limited Edition':
        return Colors.indigo.shade600;
      case 'New Arrival':
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
}
