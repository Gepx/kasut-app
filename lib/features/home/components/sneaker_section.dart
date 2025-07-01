import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart';

/// Sneaker section component (micro-frontend)
class SneakerSection extends StatelessWidget {
  final String title;
  final List<Shoe> sneakers;
  final VoidCallback? onViewAll;

  const SneakerSection({
    super.key,
    required this.title,
    required this.sneakers,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context),
            const SizedBox(height: 16),
            _buildSneakerGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'View All',
              style: TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildSneakerGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double breakpoint = 600.0;

        if (constraints.maxWidth < breakpoint) {
          return _buildMobileList();
        } else {
          return _buildDesktopGrid(constraints);
        }
      },
    );
  }

  Widget _buildMobileList() {
    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sneakers.length,
        itemBuilder: (context, index) {
          final sneaker = sneakers[index];
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: 8,
            ),
            child: SizedBox(
              width: 180, // Fixed width for mobile cards
              child: SneakerCard(
                sneaker: sneaker,
                onTap: () => _navigateToProduct(context, sneaker),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDesktopGrid(BoxConstraints constraints) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: constraints.maxWidth > 900 ? 0.55 : 0.6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: sneakers.length,
      itemBuilder: (context, index) {
        final sneaker = sneakers[index];
        return SneakerCard(
          sneaker: sneaker,
          onTap: () => _navigateToProduct(context, sneaker),
        );
      },
    );
  }

  void _navigateToProduct(BuildContext context, Shoe sneaker) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleProductPage(shoe: sneaker),
      ),
    );
  }
} 