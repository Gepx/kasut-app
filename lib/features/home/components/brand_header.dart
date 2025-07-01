import 'package:flutter/material.dart';

/// Brand info data model
class BrandInfo {
  final String name;
  final String logoPath;
  final String description;

  const BrandInfo({
    required this.name,
    required this.logoPath,
    required this.description,
  });
}

/// Brand data repository
class BrandDataRepository {
  static const Map<String, BrandInfo> brandInfo = {
    "Air Jordan": BrandInfo(
      name: "Air Jordan",
      logoPath: "assets/brands/air_jordan.png",
      description: "Air Jordan is a sub-brand of Nike created for basketball legend Michael Jordan.",
    ),
    "Adidas": BrandInfo(
      name: "Adidas",
      logoPath: "assets/brands/adidas.png",
      description: "Founded in 1949 in Germany, Adidas is one of the world's largest sportswear manufacturers.",
    ),
    "Nike": BrandInfo(
      name: "Nike",
      logoPath: "assets/brands/nike.png",
      description: "Founded in 1964, Nike has become the world's leading athletic footwear brand.",
    ),
    "Puma": BrandInfo(
      name: "Puma",
      logoPath: "assets/brands/puma.png",
      description: "Established in 1948 in Germany, Puma is a global athletic and casual footwear brand.",
    ),
    "New Balance": BrandInfo(
      name: "New Balance",
      logoPath: "assets/brands/new_balance.png",
      description: "Founded in 1906, New Balance is renowned for its commitment to quality manufacturing.",
    ),
    "Asics": BrandInfo(
      name: "Asics",
      logoPath: "assets/brands/asics.png",
      description: "Founded in 1949 in Japan, ASICS specializes in performance running shoes.",
    ),
    "OnClouds": BrandInfo(
      name: "OnClouds",
      logoPath: "assets/brands/oncloud.png",
      description: "Swiss running shoe company known for innovative CloudTec® cushioning technology.",
    ),
    "Salomon": BrandInfo(
      name: "Salomon",
      logoPath: "assets/brands/salomon.png",
      description: "Founded in 1947 in the French Alps, known for technical trail running shoes.",
    ),
    "Onisutka Tiger": BrandInfo(
      name: "Onisutka Tiger",
      logoPath: "assets/brands/onisutka_tiger.png",
      description: "Known for signature tiger design and lightweight construction.",
    ),
    "Yeezy": BrandInfo(
      name: "Yeezy",
      logoPath: "assets/brands/yeezy.png",
      description: "Fashion collaboration between Kanye West and Adidas known for distinctive aesthetics.",
    ),
  };
}

/// Brand header component (micro-frontend)
class BrandHeader extends StatelessWidget {
  final String brand;

  const BrandHeader({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    final brandInfo = BrandDataRepository.brandInfo[brand];
    
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: brandInfo != null ? Colors.white : Colors.blueGrey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: brandInfo != null ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ] : null,
      ),
      child: brandInfo != null
          ? _buildBrandInfoContent(brandInfo)
          : _buildFallbackContent(),
    );
  }

  Widget _buildBrandInfoContent(BrandInfo brandInfo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 120,
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            brandInfo.logoPath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.shopping_bag,
                size: 50,
                color: Colors.grey[400],
              );
            },
          ),
        ),
        Container(height: 100, width: 1, color: Colors.grey[300]),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  brandInfo.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  brandInfo.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackContent() {
    return Center(
      child: Text(
        '$brand Collection',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 