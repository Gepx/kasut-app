import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/features/home/components/category_carousel.dart';
import 'package:kasut/features/home/components/category_grid.dart';
import 'package:kasut/features/home/components/sneaker_section.dart';

/// Category All page component (micro-frontend)
class CategoryAll extends StatefulWidget {
  const CategoryAll({super.key});

  @override
  State<CategoryAll> createState() => _CategoryAllState();
}

class _CategoryAllState extends State<CategoryAll> {
  List<Shoe> _featuredSneakers = [];
  List<Shoe> _popularSneakers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final allShoes = await ShoeData.loadFromAsset('assets/data/products.json');

      if (allShoes.isEmpty) {
        print('Warning: No products loaded from JSON');
      }

      setState(() {
        _featuredSneakers = allShoes
            .where((shoe) =>
                shoe.tags.contains('Featured') ||
                shoe.tags.contains('Best Seller'))
            .take(8)
            .toList();

        if (_featuredSneakers.isEmpty) {
          _featuredSneakers = allShoes.take(8).toList();
        }

        _popularSneakers = allShoes
            .where((shoe) =>
                shoe.tags.contains('Most Popular') ||
                shoe.tags.contains('Popular'))
            .take(4)
            .toList();

        if (_popularSneakers.isEmpty) {
          _popularSneakers = allShoes
              .where((shoe) => !_featuredSneakers.contains(shoe))
              .take(8)
              .toList();
        }

        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CategoryCarousel(),
                  const SizedBox(height: 24),
                  const CategoryGrid(),
                  const SizedBox(height: 24),
                  SneakerSection(
                    title: 'Featured Sneakers',
                    sneakers: _featuredSneakers,
                    onViewAll: () {
                      // TODO: Navigate to view all featured sneakers
                    },
                  ),
                  const SizedBox(height: 24),
                  SneakerSection(
                    title: 'Popular Right Now',
                    sneakers: _popularSneakers,
                    onViewAll: () {
                      // TODO: Navigate to view all popular sneakers
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
