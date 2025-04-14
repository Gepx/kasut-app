import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For currency formatting
import '../models/shoe_model.dart'; // Import the Shoe model

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

  const SneakerCard({
    super.key, // Use super parameter
    required this.sneaker,
    this.width,
    this.height,
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

    // Ensure card has enough height - at least 280px for good appearance
    return Container(
      width: widget.width,
      height: widget.height ?? 280, // Set a minimum height if not provided
      child: Card(
        // Using Card for elevation and rounded corners by default
        clipBehavior: Clip.antiAlias, // Ensures image respects rounded corners
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
        ),
        elevation: 2.0, // Subtle shadow
        child: InkWell(
          // Make the whole card tappable (optional)
          onTap: () {
            // TODO: Implement navigation to product details page
            print('Tapped on card: ${widget.sneaker.name}');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sneaker Image Section - Give it more space (60% of card height)
              Expanded(
                flex: 6, // Allocate more space to the image
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        color: Colors.grey[100], // Lighter background
                        child: Padding(
                          padding: const EdgeInsets.all(
                            8.0,
                          ), // Add padding around image
                          child: Image.network(
                            // Changed from Image.asset
                            widget
                                .sneaker
                                .imageUrl, // Access sneaker via widget.
                            fit:
                                BoxFit
                                    .contain, // Use contain to see the whole shoe
                            // Optional: Add error handling for image loading
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                "Error loading image: ${widget.sneaker.imageUrl} - $error",
                              ); // Log error
                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "No image",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Favorite Icon (Top Right)
                    Positioned(
                      top: 8.0,
                      right: 8.0,
                      // Use IconButton for better semantics and tap handling
                      child: IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.black54,
                          size: 22.0, // Slightly larger icon
                        ),
                        style: IconButton.styleFrom(
                          // Add background for visibility
                          backgroundColor: Colors.white.withOpacity(0.7),
                          padding: const EdgeInsets.all(6),
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                            // TODO: Add logic to persist favorite state if needed
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Sneaker Details Section (40% of card height)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(
                    12.0,
                  ), // Padding for text content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Use minimum space needed
                    children: [
                      // Brand Name
                      // Brand Name (with potential flame icon - represented by text for now)
                      // TODO: Add conditional flame icon if logic is defined
                      Text(
                        widget.sneaker.brand, // Keep original casing
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0), // Spacing
                      // Sneaker Name
                      Text(
                        widget.sneaker.name,
                        style:
                            textTheme
                                .bodyMedium, // Use bodyMedium for consistency
                        maxLines: 2, // Allow up to two lines for the name
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0), // Spacing
                      // Lowest Ask Label
                      Text(
                        'Lowest Ask',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.grey[600],
                        ), // Smaller grey label
                      ),
                      const SizedBox(height: 2.0), // Less spacing
                      // Current Price
                      Text(
                        currencyFormatter.format(widget.sneaker.price),
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ), // Larger bold price
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Optional: Old Price (Strikethrough)
                      if (widget.sneaker.oldPrice != null &&
                          widget.sneaker.oldPrice! > widget.sneaker.price)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            currencyFormatter.format(widget.sneaker.oldPrice!),
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                              decoration:
                                  TextDecoration.lineThrough, // Strikethrough
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ), // End Column
        ), // End InkWell
      ),
    );
  }
}
