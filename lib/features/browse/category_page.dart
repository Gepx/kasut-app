import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart';

class CategoryPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryPage({super.key, required this.categoryTitle});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<List<Shoe>> _shoes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShoes();
  }

  Future<void> _loadShoes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load all shoes
      final allShoes = await ShoeData.loadFromAsset(
        'assets/data/products.json',
      );

      // Filter based on category
      List<Shoe> filteredShoes = [];

      // Apply different filtering logic based on category
      final categoryLower = widget.categoryTitle.toLowerCase();

      switch (categoryLower) {
        case 'mens': // Category title is "Mens"
          filteredShoes =
              allShoes.where((shoe) {
                // Use the correct JSON key "men"
                return shoe.sizes.containsKey('men') &&
                    shoe.sizes['men']!.isNotEmpty;
              }).toList();
          break;

        case 'womens': // Category title is "Womens"
          filteredShoes =
              allShoes.where((shoe) {
                // Use the correct JSON key "women"
                return shoe.sizes.containsKey('women') &&
                    shoe.sizes['women']!.isNotEmpty;
              }).toList();
          break;

        case 'kids': // Category title is "Kids", JSON key is "kids"
          filteredShoes =
              allShoes.where((shoe) {
                // JSON key is already lowercase "kids"
                return shoe.sizes.containsKey('kids') &&
                    shoe.sizes['kids']!.isNotEmpty;
              }).toList();
          break;

        case 'air jordan':
          filteredShoes = ShoeData.getByBrand('Air Jordan');
          break;

        case 'asics':
          filteredShoes = ShoeData.getByBrand('Asics');
          break;

        case 'oncloud':
          filteredShoes = ShoeData.getByBrand('OnClouds');
          break;

        case 'samba':
          filteredShoes =
              allShoes
                  .where((shoe) => shoe.name.toLowerCase().contains('samba'))
                  .toList();
          break;

        case '2025 arrivals':
          filteredShoes =
              allShoes
                  .where((shoe) => shoe.releaseDate.startsWith('2025'))
                  .toList();
          break;

        default:
          filteredShoes = allShoes;
      }

      setState(() {
        _shoes = Future.value(filteredShoes);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading shoes: $e');
      setState(() {
        _shoes = Future.value([]);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryTitle), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<Shoe>>(
                future: _shoes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No shoes found for ${widget.categoryTitle}'),
                    );
                  }

                  final shoes = snapshot.data!;

                  // Use LayoutBuilder for responsive grid
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine crossAxisCount based on screen width
                      final double screenWidth = constraints.maxWidth;
                      final int crossAxisCount =
                          screenWidth >= 800
                              ? 8
                              : 2; // 8 for desktop, 2 for mobile
                      final double aspectRatio =
                          screenWidth >= 800
                              ? 0.8
                              : 0.7; // Adjust aspect ratio if needed

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount, // Use dynamic count
                          childAspectRatio:
                              aspectRatio, // Use dynamic aspect ratio
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: shoes.length,
                        itemBuilder: (context, index) {
                          return SneakerCard(
                            sneaker: shoes[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          SingleProductPage(shoe: shoes[index]),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
    );
  }
}
