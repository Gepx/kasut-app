import 'package:flutter/material.dart';
import 'package:kasut/features/home/home_all.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart';

/// Home tab content manager following micro-frontend architecture
class HomeTabContent {
  /// Create tab content based on brand
  static Widget createTab(String brand) {
    if (brand == "All") {
      return const CategoryAll();
    } else {
      return BrandTabContent(brand: brand);
    }
  }
}

/// Brand-specific tab content widget
class BrandTabContent extends StatelessWidget {
  final String brand;

  const BrandTabContent({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Shoe>>(
      future: _loadBrandSneakers(brand),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading $brand sneakers: ${snapshot.error}',
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return BrandContentWidget(brand: brand, sneakers: []);
        } else {
          return BrandContentWidget(
            brand: brand,
            sneakers: snapshot.data!,
          );
        }
      },
    );
  }

  Future<List<Shoe>> _loadBrandSneakers(String brand) async {
    try {
      if (ShoeData.shoes.isEmpty) {
        await ShoeData.loadFromAsset('assets/data/products.json');
      }
      return ShoeData.getByBrand(brand);
    } catch (e) {
      print('Error loading sneakers for brand $brand: $e');
      return [];
    }
  }
}

/// Widget for displaying brand-specific content
class BrandContentWidget extends StatelessWidget {
  final String brand;
  final List<Shoe> sneakers;

  const BrandContentWidget({
    super.key,
    required this.brand,
    required this.sneakers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _buildBrandHeader(),
        _buildBrandTitle(context),
        const SizedBox(height: 16),
        sneakers.isEmpty
            ? _buildEmptyState(context)
            : _buildSneakerGrid(context, sneakers),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBrandHeader() {
    // Brand banner placeholder
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '$brand Collection',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBrandTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '$brand Sneakers',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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

  Widget _buildSneakerGrid(BuildContext context, List<Shoe> sneakers) {
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