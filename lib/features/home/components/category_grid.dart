import 'package:flutter/material.dart';
import 'package:kasut/features/browse/category_page.dart';

/// Category data model
class CategoryData {
  final String title;
  final String image;

  const CategoryData({required this.title, required this.image});
}

/// Category grid component (micro-frontend)
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  static const List<CategoryData> _categories = [
    CategoryData(title: "Mens", image: "assets/home/mens.png"),
    CategoryData(title: "Womens", image: "assets/home/womens.png"),
    CategoryData(title: "Kids", image: "assets/home/kids.png"),
    CategoryData(title: "2025 Arrivals", image: "assets/home/arrivals.png"),
    CategoryData(title: "Air Jordan", image: "assets/home/airjordan.png"),
    CategoryData(title: "Asics", image: "assets/home/asics.png"),
    CategoryData(title: "onCloud", image: "assets/home/oncloud.png"),
    CategoryData(title: "Samba", image: "assets/home/samba.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              const double breakpoint = 800.0;
              final bool isLargeScreen = constraints.maxWidth >= breakpoint;
              final int crossAxisCount = isLargeScreen ? 8 : 4;
              final double imageSize = isLargeScreen ? 80.0 : 60.0;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  _categories.length,
                  (index) => _CategoryCard(
                    category: _categories[index],
                    imageSize: imageSize,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Individual category card widget
class _CategoryCard extends StatelessWidget {
  final CategoryData category;
  final double imageSize;

  const _CategoryCard({
    required this.category,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              categoryTitle: category.title,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              category.image,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              category.title,
              style: const TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 