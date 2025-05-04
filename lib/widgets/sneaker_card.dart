import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For currency formatting
import '../models/shoe_model.dart'; // Import the Shoe model
import 'image_loader.dart'; // Import the AssetImageLoader

/// A reusable card widget to display sneaker information.
///
/// Takes a [Shoe] object and displays its image, brand, name, and price
/// in a styled card format based on the design reference.
class SneakerCard extends StatefulWidget {
  // Changed to StatefulWidget
  final Shoe sneaker;
  // Add optional width and height parameters for more flexible sizing
  final double? width;
  final double? height;
  final Function()? onTap;

  const SneakerCard({
    super.key, // Use super parameter
    required this.sneaker,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  State<SneakerCard> createState() => _SneakerCardState();
}

class _SneakerCardState extends State<SneakerCard> {
  // Added State class
  bool _isFavorite = false; // State for favorite button

  @override
  Widget build(BuildContext context) {
    // Currency formatter for IDR
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'IDR ', // Keep space for separation
      decimalDigits: 0, // No decimal digits for IDR
    );
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: widget.width,
        height:
            widget.height ??
            260, // Reduced from 320 to 260 for more compact cards
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
                    padding: const EdgeInsets.all(
                      8,
                    ), // Reduced padding from 12 to 8
                    child: AssetImageLoader(
                      imagePath: widget.sneaker.firstPict,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Favorite Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.black,
                          size: 20, // Reduced size from 24 to 20
                        ),
                      ),
                    ),
                  ),

                  // Tags (Best Seller, etc)
                  if (widget.sneaker.tags.isNotEmpty)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6, // Reduced padding from 8 to 6
                          vertical: 3, // Reduced padding from 4 to 3
                        ),
                        decoration: BoxDecoration(
                          color: _getTagColor(widget.sneaker.tags.first),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.sneaker.tags.first,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9, // Reduced font size from 10 to 9
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Info Section - Using fixed height layout
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
                          widget.sneaker.brand,
                          style: const TextStyle(
                            fontSize: 14, // Reduced from 16 to 14
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
                    widget.sneaker.name,
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
                        widget.sneaker.discountPrice != null
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Discounted Price
                                Text(
                                  currencyFormatter.format(
                                    widget.sneaker.discountPrice,
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
                                    widget.sneaker.price,
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
                              currencyFormatter.format(widget.sneaker.price),
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
