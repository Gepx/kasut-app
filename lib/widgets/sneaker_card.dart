import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/image_loader.dart';
import 'package:kasut/providers/wishlist_provider.dart';

/// A lightweight sneaker product card that works across mobile-first breakpoints.
///
/// It shows: product image, brand, name and price (plus discount if any)
/// together with a heart-icon to add/remove the item from wishlist.
class SneakerCard extends StatelessWidget {
  const SneakerCard({
    super.key,
    required this.sneaker,
    this.onTap,
    this.width,
    this.height,
  });

  final Shoe sneaker;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'id_ID', symbol: 'IDR ', decimalDigits: 0);

    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: 1,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with optional wishlist heart
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AssetImageLoader(
                        imagePath: sneaker.firstPict,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _WishlistButton(sku: sneaker.sku),
                    ),
                    // Tag icons (e.g. Best Seller, Free Delivery)
                    if (sneaker.tags.isNotEmpty)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _TagIconOverlay(tags: sneaker.tags),
                      ),

                    // Discount badge moves slightly lower if tag icons present
                    if (sneaker.discountPrice != null)
                      Positioned(
                        top: sneaker.tags.isNotEmpty ? 32 : 8,
                        left: 8,
                        child: _DiscountBadge(price: sneaker.price, discountPrice: sneaker.discountPrice!),
                      ),
                  ],
                ),
              ),

              // Info section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sneaker.brand,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sneaker.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Price row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            sneaker.discountPrice != null
                                ? fmt.format(sneaker.discountPrice!)
                                : fmt.format(sneaker.price),
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: sneaker.discountPrice != null ? Colors.red : Colors.black,
                                ),
                          ),
                          if (sneaker.discountPrice != null) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                fmt.format(sneaker.price),
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey[500],
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper widgets ---------------------------------------------------------

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.sku});
  final String sku;

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, provider, _) {
        final inWishlist = provider.isInWishlist(sku);
        return InkWell(
          onTap: () => provider.toggleWishlist(sku),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              inWishlist ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: inWishlist ? Colors.red : Colors.black,
            ),
          ),
        );
      },
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.price, required this.discountPrice});
  final double price;
  final double discountPrice;

  @override
  Widget build(BuildContext context) {
    final percent = (((price - discountPrice) / price) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6)),
      child: Text(
        '-$percent%',
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Displays small icons representing tags such as Most Popular, Free Delivery etc.
class _TagIconOverlay extends StatelessWidget {
  const _TagIconOverlay({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final List<Widget> icons = [];

    if (tags.contains('Most Popular')) {
      icons.add(const Icon(Icons.trending_up, size: 14, color: Colors.black));
    }
    if (tags.contains('Best Seller')) {
      icons.add(const Icon(Icons.star, size: 14, color: Colors.black));
    }
    if (tags.contains('Free Delivery')) {
      icons.add(const Icon(Icons.local_shipping, size: 14, color: Colors.black));
    }
    if (tags.contains('Special Price')) {
      icons.add(const Icon(Icons.local_offer, size: 14, color: Colors.black));
    }

    if (icons.isEmpty) return const SizedBox.shrink();

    return Row(children: [
      ...icons.asMap().entries.map((entry) {
        final isLast = entry.key == icons.length - 1;
        return Padding(
          padding: EdgeInsets.only(right: isLast ? 0 : 4),
          child: Tooltip(message: tags[entry.key], child: entry.value),
        );
      }).toList(),
    ]);
  }
} 