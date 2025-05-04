import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Shoe {
  final String name;
  final String brand;
  final double price;
  final double? discountPrice;
  final String firstPict;
  final String secondPict;
  final String thirdPict;
  final Map<String, List<double>> sizes;
  final List<String> tags;
  final String description;
  final String color;
  final String sku;
  final String releaseDate;

  const Shoe({
    required this.name,
    required this.brand,
    required this.price,
    this.discountPrice,
    required this.firstPict,
    required this.secondPict,
    required this.thirdPict,
    required this.sizes,
    required this.tags,
    required this.description,
    required this.color,
    required this.sku,
    required this.releaseDate,
  });

  // Factory constructor to create a Shoe from a JSON map
  factory Shoe.fromJson(Map<String, dynamic> json) {
    // Clean up image paths that might contain newlines from the JSON file
    String cleanPath(String path) {
      if (path.contains('\n')) {
        return path.replaceAll(RegExp(r'\s*\n\s*'), '').trim();
      }
      return path;
    }

    // Use default placeholder if image paths are invalid
    const String defaultPlaceholder = 'assets/brands/placeholder.png';

    // Extract name and brand for use in path resolution
    final name = json['name'] as String;
    final brand = json['brand'] as String;

    // Handle special case for brand folder name mappings
    String normalizeBrandPath(String brandName) {
      // Create a map of brand name variations to folder names
      final Map<String, String> brandFolderNames = {
        'air jordan': 'Air Jordan',
        'onclouds': 'OnClouds',
        'on': 'OnClouds',
        'onitsuka tiger': 'Onisutka Tiger',
        'new balance': 'New Balance',
        'asics': 'Asics',
        'nike': 'Nike',
        'adidas': 'Adidas',
        'puma': 'Puma',
        'salomon': 'Salomon',
        'yeezy': 'Yeezy',
      };

      // Get normalized folder name or use the original brand name
      final String normalizedBrand = brandName.toLowerCase();
      return brandFolderNames[normalizedBrand] ?? brandName;
    }

    // Process image paths to ensure they're correctly formatted and URL-safe
    String processImagePath(String path) {
      // Clean up newlines first
      String cleanedPath = cleanPath(path);

      // If path already contains the full path, return it
      if (cleanedPath.startsWith('assets/brand-products/')) {
        return cleanedPath;
      }

      // Otherwise construct path based on brand name
      final normalizedBrand = normalizeBrandPath(brand);

      // Replace spaces in filenames with underscores to avoid encoding issues
      final String safeFileName = cleanedPath.replaceAll(' ', '_');

      return 'assets/brand-products/$normalizedBrand/$safeFileName';
    }

    // Ensure these images exist or fallback to placeholders
    final firstPict =
        json.containsKey('firstPict') && json['firstPict'] != null
            ? processImagePath(json['firstPict'] as String)
            : defaultPlaceholder;

    final secondPict =
        json.containsKey('secondPict') && json['secondPict'] != null
            ? processImagePath(json['secondPict'] as String)
            : defaultPlaceholder;

    final thirdPict =
        json.containsKey('thirdPict') && json['thirdPict'] != null
            ? processImagePath(json['thirdPict'] as String)
            : defaultPlaceholder;

    return Shoe(
      name: name,
      brand: brand,
      price: (json['price'] as num).toDouble(),
      discountPrice:
          json['discountPrice'] != null
              ? (json['discountPrice'] as num).toDouble()
              : null,
      firstPict: firstPict,
      secondPict: secondPict,
      thirdPict: thirdPict,
      sizes: _parseSizes(json['sizes'] as Map<String, dynamic>),
      tags: List<String>.from(json['tags'] as List),
      description: json['description'] as String,
      color: json['color'] as String,
      sku: json['sku'] as String,
      releaseDate: json['releaseDate'] as String,
    );
  }

  // Helper method to parse sizes
  static Map<String, List<double>> _parseSizes(Map<String, dynamic> sizeJson) {
    Map<String, List<double>> result = {};

    sizeJson.forEach((key, value) {
      if (value is List) {
        result[key] = List<double>.from(
          value.map((item) => (item as num).toDouble()),
        );
      }
    });

    return result;
  }

  // Get main image url (used for compatibility with original code)
  String get imageUrl => firstPict;
}

// ShoeData class provides methods to load shoes from JSON
class ShoeData {
  static List<Shoe> _shoes = [];
  static bool _isLoading = false;
  static String? _lastError;

  // Return the cached shoe list
  static List<Shoe> get shoes => _shoes;

  // Check if shoes are currently loading
  static bool get isLoading => _isLoading;

  // Get the last error if any
  static String? get lastError => _lastError;

  // Load shoes from JSON string
  static Future<List<Shoe>> loadFromJson(String jsonString) async {
    try {
      _isLoading = true;
      _lastError = null;

      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      _shoes =
          jsonList
              .map((json) => Shoe.fromJson(json as Map<String, dynamic>))
              .toList();

      _isLoading = false;
      // Log the number of shoes loaded
      print('Successfully loaded ${_shoes.length} shoes');

      // For detailed debugging, you can use JsonEncoder to pretty-print the first shoe
      if (_shoes.isNotEmpty) {
        final encoder = JsonEncoder.withIndent('  ');
        // Create a simplified list of all shoes with key information
        final simplifiedShoes =
            _shoes
                .map(
                  (shoe) => {
                    'name': shoe.name,
                    'brand': shoe.brand,
                    'price': shoe.price,
                    'discountPrice': shoe.discountPrice,
                  },
                )
                .toList();

        // Log number of shoes and print all shoes in a structured format
        print('Loaded ${_shoes.length} shoes:');
        print(encoder.convert(simplifiedShoes));
      }
      return _shoes;
    } catch (e) {
      print('Error parsing JSON: $e');
      _lastError = 'Error parsing JSON: $e';
      _isLoading = false;
      return [];
    }
  }

  // Load shoes from asset file
  static Future<List<Shoe>> loadFromAsset(String assetPath) async {
    if (_shoes.isNotEmpty) {
      // Return cached data if available
      return _shoes;
    }

    try {
      _isLoading = true;
      _lastError = null;

      final String jsonString = await rootBundle.loadString(assetPath);
      final shoes = await loadFromJson(jsonString);

      // If no shoes loaded from JSON, use mock data instead
      if (shoes.isEmpty) {
        print('No shoes found in JSON, using mock data instead');
        _shoes = generateMockShoes();
      }

      _isLoading = false;
      return _shoes;
    } catch (e) {
      print('Error loading shoes from asset: $e, using mock data instead');
      _lastError = 'Error loading shoes from asset: $e';
      _isLoading = false;

      // Use mock data as fallback
      _shoes = generateMockShoes();
      return _shoes;
    }
  }

  // Helper to normalize brand names for better matching
  static String _normalizeBrandName(String brand) {
    // Remove spaces, convert to lowercase for initial check
    String normalizedCheck = brand.toLowerCase().replaceAll(' ', '');

    // Handle special cases - return the desired display/comparison name
    if (normalizedCheck == 'oncloud' || normalizedCheck == 'on') {
      return 'OnClouds';
    }
    if (normalizedCheck == 'newbalance' || normalizedCheck == 'nb') {
      return 'New Balance';
    }
    if (normalizedCheck == 'onitsukatiger') {
      return 'Onisutka Tiger'; // Corrected spelling based on folder name
    }
    if (normalizedCheck == 'airjordan') {
      // Handles "AirJordan" from JSON
      return 'Air Jordan';
    }

    // If no special mapping, return the original brand name as passed.
    // The comparison in getByBrand should handle potential case differences.
    return brand;
  }

  // Get shoes filtered by brand
  static List<Shoe> getByBrand(String brand) {
    if (brand.isEmpty) return _shoes;

    // Normalize the target brand name from the tab/filter
    final normalizedTargetBrand = _normalizeBrandName(brand);

    return _shoes.where((shoe) {
      // Normalize the brand name from the shoe data
      final normalizedShoeBrand = _normalizeBrandName(shoe.brand);

      // Perform a case-insensitive comparison for robustness
      return normalizedShoeBrand.toLowerCase() ==
              normalizedTargetBrand.toLowerCase() ||
          shoe.tags.any(
            (tag) => _normalizeBrandName(
              tag,
            ).toLowerCase().contains(normalizedTargetBrand.toLowerCase()),
          );
    }).toList();
  }

  // Clear cached data (useful for testing)
  static void clearCache() {
    _shoes = [];
    _lastError = null;
    _isLoading = false;
  }

  // Generate mock data for testing when no products are loaded
  static List<Shoe> generateMockShoes() {
    return [
      Shoe(
        name: "Samba OG Cloud White Core Black",
        brand: "Adidas",
        price: 2200000,
        discountPrice: 1290000,
        firstPict:
            "assets/brand-products/Adidas/Adidas_Samba_OG_Cloud_White_Core_Black_1.png",
        secondPict:
            "assets/brand-products/Adidas/Adidas_Samba_OG_Cloud_White_Core_Black_2.png",
        thirdPict:
            "assets/brand-products/Adidas/Adidas_Samba_OG_Cloud_White_Core_Black_3.png",
        sizes: {
          "men":
              [
                39,
                40,
                41,
                42,
                43,
                44,
                45,
              ].map((size) => size.toDouble()).toList(),
        },
        tags: ["Best Seller", "Popular"],
        description:
            "The Adidas Samba OG in Cloud White and Core Black combines timeless design with modern comfort. This iconic shoe features a leather upper with suede overlays, a gum sole, and the classic three stripes.",
        color: "Cloud White/Core Black",
        sku: "BY2967",
        releaseDate: "2022-05-15",
      ),
      Shoe(
        name: "P-6000 Metallic Silver Sail",
        brand: "Nike",
        price: 1729000,
        discountPrice: 1200000,
        firstPict:
            "assets/brand-products/Nike/Nike_P-6000_Metallic_Silver_Sail_1.png",
        secondPict:
            "assets/brand-products/Nike/Nike_P-6000_Metallic_Silver_Sail_2.png",
        thirdPict:
            "assets/brand-products/Nike/Nike_P-6000_Metallic_Silver_Sail_3.png",
        sizes: {
          "men": [40, 41, 42, 43, 44].map((size) => size.toDouble()).toList(),
        },
        tags: ["Featured", "Most Popular"],
        description:
            "The Nike P-6000 in Metallic Silver and Sail brings back Y2K running aesthetics with a modern twist. This retro-inspired silhouette features metallic overlays, a cushy foam midsole, and durable rubber outsole.",
        color: "Metallic Silver/Sail",
        sku: "CW3131-001",
        releaseDate: "2023-03-10",
      ),
      Shoe(
        name: "Cloudnova Z5 White Flame",
        brand: "OnCloud",
        price: 2500000,
        discountPrice: 2100000,
        firstPict:
            "assets/brand-products/OnCloud/OnCloud_Cloudnova_Z5_White_Flame_1.png",
        secondPict:
            "assets/brand-products/OnCloud/OnCloud_Cloudnova_Z5_White_Flame_2.png",
        thirdPict:
            "assets/brand-products/OnCloud/OnCloud_Cloudnova_Z5_White_Flame_3.png",
        sizes: {
          "men": [41, 42, 43, 44, 45].map((size) => size.toDouble()).toList(),
        },
        tags: ["New Arrival", "Free Delivery"],
        description:
            "The OnCloud Cloudnova Z5 in White Flame combines performance and style with Swiss engineering. Featuring CloudTec® cushioning, a speed-lacing system, and breathable upper for all-day comfort.",
        color: "White/Flame",
        sku: "OC-CN-Z5-WF",
        releaseDate: "2023-08-21",
      ),
      // Adding an Air Jordan mock example with the correct folder name
      Shoe(
        name: "Air Jordan 4 Retro SB Navy",
        brand: "Air Jordan",
        price: 3500000,
        discountPrice: 3200000,
        firstPict:
            "assets/brand-products/AirJordan/Air Jordan 4 Retro SB Navy - 1.png",
        secondPict:
            "assets/brand-products/AirJordan/Air Jordan 4 Retro SB Navy - 2.png",
        thirdPict:
            "assets/brand-products/AirJordan/Air Jordan 4 Retro SB Navy - 3.png",
        sizes: {
          "men":
              [40, 41, 42, 43, 44, 45].map((size) => size.toDouble()).toList(),
        },
        tags: ["Limited Edition", "SB Collection"],
        description:
            "The Air Jordan 4 Retro SB Navy brings skate-ready durability to the iconic basketball silhouette. Featuring premium materials with navy blue suede upper, gum outsoles, and signature Air cushioning.",
        color: "Navy/Gum",
        sku: "AJ4-SB-NVY-001",
        releaseDate: "2023-05-17",
      ),
    ];
  }
}
