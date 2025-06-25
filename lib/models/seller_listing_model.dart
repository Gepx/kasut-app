import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/utils/indonesian_utils.dart';

/// Seller listing that references an existing product
class SellerListing {
  final String id;
  final String sellerId;
  final String sellerName;
  final Shoe originalProduct; // Reference to the original shoe
  final ProductCondition condition;
  final double sellerPrice;
  final String selectedSize;
  final List<String> sellerImages; // Seller's own photos
  final String? conditionNotes;
  final DateTime listedDate;
  final bool isActive;
  final int quantity;
  final int? views;

  SellerListing({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.originalProduct,
    required this.condition,
    required this.sellerPrice,
    required this.selectedSize,
    required this.sellerImages,
    this.conditionNotes,
    required this.listedDate,
    this.isActive = true,
    this.quantity = 1,
    this.views,
  });

  /// Get display price in Rupiah
  String get displayPrice => IndonesianUtils.formatRupiah(sellerPrice);

  /// Get short price format
  String get shortPrice => IndonesianUtils.formatRupiahShort(sellerPrice);

  /// Get original brand new price
  String get originalPrice => IndonesianUtils.formatRupiah(originalProduct.price);

  /// Calculate price difference from original
  double get priceDifference => originalProduct.price - sellerPrice;

  /// Get percentage discount from original price
  double get discountPercentage => 
      ((originalProduct.price - sellerPrice) / originalProduct.price) * 100;

  /// Check if price is valid (not exceeding original)
  bool get isPriceValid => sellerPrice <= originalProduct.price;

  /// Get condition display text
  String get conditionText => condition.label;

  /// Get time since listed
  String get timeSinceListed {
    final now = DateTime.now();
    final difference = now.difference(listedDate);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam yang lalu';
    } else {
      return '${difference.inMinutes} menit yang lalu';
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productSku': originalProduct.sku,
      'productName': originalProduct.name,
      'productBrand': originalProduct.brand,
      'productImage': originalProduct.firstPict,
      'originalPrice': originalProduct.price,
      'condition': condition.name,
      'sellerPrice': sellerPrice,
      'selectedSize': selectedSize,
      'sellerImages': sellerImages,
      'conditionNotes': conditionNotes,
      'listedDate': listedDate.toIso8601String(),
      'isActive': isActive,
      'quantity': quantity,
      'views': views ?? 0,
    };
  }

  /// Create from JSON (requires shoe data to be loaded separately)
  static SellerListing fromJson(Map<String, dynamic> json) {
    // For now, we'll create a basic shoe object from the stored data
    // In a real app, you'd look up the full shoe by SKU
    final shoe = Shoe(
      name: json['productName'] ?? 'Unknown Product',
      brand: json['productBrand'] ?? 'Unknown Brand', 
      price: json['originalPrice']?.toDouble() ?? 0.0,
      sku: json['productSku'] ?? '',
      firstPict: json['productImage'] ?? 'assets/brands/placeholder.png',
      secondPict: json['productImage'] ?? 'assets/brands/placeholder.png',
      thirdPict: json['productImage'] ?? 'assets/brands/placeholder.png',
      sizes: {'men': [40, 41, 42, 43, 44]}, // Default sizes
      tags: [],
      description: '',
      color: '',
      releaseDate: '',
    );
    return SellerListing(
      id: json['id'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      originalProduct: shoe,
      condition: ProductCondition.values.firstWhere(
        (c) => c.name == json['condition'],
        orElse: () => ProductCondition.lainnya,
      ),
      sellerPrice: json['sellerPrice'].toDouble(),
      selectedSize: json['selectedSize'],
      sellerImages: List<String>.from(json['sellerImages']),
      conditionNotes: json['conditionNotes'],
      listedDate: DateTime.parse(json['listedDate']),
      isActive: json['isActive'] ?? true,
      quantity: json['quantity'] ?? 1,
      views: json['views'],
    );
  }

  /// Create a copy with updated fields
  SellerListing copyWith({
    String? id,
    String? sellerId,
    String? sellerName,
    Shoe? originalProduct,
    ProductCondition? condition,
    double? sellerPrice,
    String? selectedSize,
    List<String>? sellerImages,
    String? conditionNotes,
    DateTime? listedDate,
    bool? isActive,
    int? quantity,
    int? views,
  }) {
    return SellerListing(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      originalProduct: originalProduct ?? this.originalProduct,
      condition: condition ?? this.condition,
      sellerPrice: sellerPrice ?? this.sellerPrice,
      selectedSize: selectedSize ?? this.selectedSize,
      sellerImages: sellerImages ?? this.sellerImages,
      conditionNotes: conditionNotes ?? this.conditionNotes,
      listedDate: listedDate ?? this.listedDate,
      isActive: isActive ?? this.isActive,
      quantity: quantity ?? this.quantity,
      views: views ?? this.views,
    );
  }
}

 