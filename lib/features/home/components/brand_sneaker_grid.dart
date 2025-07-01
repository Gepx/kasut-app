import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart';

/// Brand sneaker grid component (micro-frontend)
class BrandSneakerGrid extends StatelessWidget {
  final List<Shoe> sneakers;

  const BrandSneakerGrid({super.key, required this.sneakers});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        double childAspectRatio = 0.55;

        if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
          crossAxisCount = 3;
          childAspectRatio = 0.6;
        } else if (constraints.maxWidth >= 900 && constraints.maxWidth < 1200) {
          crossAxisCount = 4;
          childAspectRatio = 0.6;
        } else if (constraints.maxWidth >= 1200 && constraints.maxWidth < 1600) {
          crossAxisCount = 7;
          childAspectRatio = 0.55;
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: sneakers.length,
          itemBuilder: (context, index) {
            return SneakerCard(
              sneaker: sneakers[index],
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SingleProductPage(shoe: sneakers[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Empty state widget for when no sneakers are found
class EmptyBrandState extends StatelessWidget {
  final String brand;

  const EmptyBrandState({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No $brand sneakers found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new arrivals',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 