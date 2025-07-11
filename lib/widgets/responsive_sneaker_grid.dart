import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/models/seller_listing_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/utils/responsive_utils.dart';
import 'package:kasut/utils/indonesian_utils.dart';

/// Mobile-first responsive grid for displaying sneakers and seller listings
class ResponsiveSneakerGrid extends StatelessWidget {
  final List<Shoe>? shoes;
  final List<SellerListing>? listings;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? emptyWidget;
  final bool showSellerInfo;

  const ResponsiveSneakerGrid({
    super.key,
    this.shoes,
    this.listings,
    this.scrollController,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.emptyWidget,
    this.showSellerInfo = false,
  }) : assert(
         shoes != null || listings != null,
         'Either shoes or listings must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final items =
        shoes ?? listings?.map((l) => l.originalProduct).toList() ?? [];

    if (items.isEmpty) {
      return emptyWidget ?? _buildEmptyState();
    }

    return ResponsiveBuilder(
      builder: (context, deviceType, width) {
        final responsivePadding =
            padding ?? ResponsiveUtils.getResponsivePadding(width);
        final crossAxisCount = ResponsiveUtils.getProductGridColumns(width);
        final aspectRatio = ResponsiveUtils.getProductCardAspectRatio(width);
        final spacing = ResponsiveUtils.getSpacing(width, SpacingSize.sm);

        return GridView.builder(
          controller: scrollController,
          padding: responsivePadding,
          shrinkWrap: shrinkWrap,
          physics: physics,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (listings != null) {
              return _buildListingCard(listings![index], width);
            } else {
              return _buildSneakerCard(items[index], width);
            }
          },
        );
      },
    );
  }

  Widget _buildSneakerCard(Shoe shoe, double width) {
    return SneakerCard(
      sneaker: shoe,
      onTap: () {
        // Navigate to product detail
        // Note: This would need proper navigation context
      },
    );
  }

  Widget _buildListingCard(SellerListing listing, double width) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to listing detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with condition badge
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Image.asset(
                      listing.originalProduct.firstPict,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                    ),
                  ),
                  // Condition badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getConditionColor(listing.condition),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        listing.conditionText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Discount badge if applicable
                  if (listing.discountPercentage > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${listing.discountPercentage.round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Product info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveUtils.getSpacing(width, SpacingSize.sm),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      listing.originalProduct.name,
                      style: TextStyle(
                        fontSize:
                            ResponsiveUtils.isSmallMobile(width) ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Size and seller info
                    Text(
                      'Size ${listing.selectedSize}${showSellerInfo ? ' • ${listing.sellerName}' : ''}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    // Price section
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listing.shortPrice,
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.isSmallMobile(width)
                                          ? 12
                                          : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (listing.discountPercentage > 0)
                                Text(
                                  IndonesianUtils.formatRupiahShort(
                                    listing.originalProduct.price,
                                  ),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada produk ditemukan',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Color _getConditionColor(ProductCondition condition) {
    switch (condition) {
      case ProductCondition.brandNew:
        return Colors.green;
      case ProductCondition.denganBox:
        return Colors.blue;
      case ProductCondition.tanpaBox:
        return Colors.orange;
      case ProductCondition.lainnya:
        return Colors.grey[600]!;
    }
  }
}

/// Horizontal scrolling sneaker list for featured/popular sections
class HorizontalSneakerList extends StatelessWidget {
  final List<Shoe>? shoes;
  final List<SellerListing>? listings;
  final String? title;
  final VoidCallback? onViewAll;
  final double height;
  final bool showSellerInfo;

  const HorizontalSneakerList({
    super.key,
    this.shoes,
    this.listings,
    this.title,
    this.onViewAll,
    this.height = 280,
    this.showSellerInfo = false,
  }) : assert(
         shoes != null || listings != null,
         'Either shoes or listings must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final items =
        shoes ?? listings?.map((l) => l.originalProduct).toList() ?? [];

    if (items.isEmpty) return const SizedBox();

    return ResponsiveBuilder(
      builder: (context, deviceType, width) {
        final padding = ResponsiveUtils.getResponsivePadding(width);
        final itemWidth =
            width * (ResponsiveUtils.isSmallMobile(width) ? 0.42 : 0.45);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and view all button
            if (title != null)
              Padding(
                padding: padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (onViewAll != null)
                      TextButton(
                        onPressed: onViewAll,
                        child: const Text('View All'),
                      ),
                  ],
                ),
              ),
            // Horizontal list
            SizedBox(
              height: height,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: padding.horizontal / 2,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final isFirst = index == 0;
                  final isLast = index == items.length - 1;

                  return Container(
                    width: itemWidth,
                    margin: EdgeInsets.only(
                      left: isFirst ? padding.horizontal / 2 : 4,
                      right: isLast ? padding.horizontal / 2 : 4,
                    ),
                    child:
                        listings != null
                            ? _buildListingCard(listings![index], width)
                            : _buildSneakerCard(items[index], width),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSneakerCard(Shoe shoe, double width) {
    return SneakerCard(
      sneaker: shoe,
      onTap: () {
        // Navigate to product detail
      },
    );
  }

  Widget _buildListingCard(SellerListing listing, double width) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to listing detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  listing.originalProduct.firstPict,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.originalProduct.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.shortPrice,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            listing.conditionText,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
}
