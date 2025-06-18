import 'dart:convert';
import 'dart:math';
import 'package:kasut/models/seller_listing_model.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/utils/indonesian_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Service for managing seller listings in the frontend-only app
class SellerListingService {
  static const String _storageKey = 'seller_listings';
  static List<SellerListing> _allListings = [];
  static const _uuid = Uuid();

  /// Initialize with mock data
  static Future<void> initialize() async {
    await _loadListings();
    if (_allListings.isEmpty) {
      await _createMockListings();
    }
  }

  /// Create mock seller listings for demonstration
  static Future<void> _createMockListings() async {
    // Sample seller accounts
    final mockSellers = [
      {'email': 'ahmad@example.com', 'name': 'Ahmad Pratama'},
      {'email': 'siti@example.com', 'name': 'Siti Nurhaliza'},
      {'email': 'budi@example.com', 'name': 'Budi Santoso'},
      {'email': 'rina@example.com', 'name': 'Rina Wati'},
    ];

    // Load available shoes from JSON data
    final shoes = await _loadShoesFromAssets();
    final random = Random();

    final mockListings = <SellerListing>[];

    for (int i = 0; i < 15; i++) {
      final shoe = shoes[random.nextInt(shoes.length)];
      final seller = mockSellers[random.nextInt(mockSellers.length)];
      
      // Random condition and pricing
      final conditions = ProductCondition.values;
      final condition = conditions[random.nextInt(conditions.length)];
      
      // Price is 70-95% of original price
      final discountPercent = 5 + random.nextInt(25);
      final sellerPrice = shoe.price * (100 - discountPercent) / 100;
      
      // Random size from available sizes
      final availableSizes = ['38', '39', '40', '41', '42', '43', '44', '45'];
      final selectedSize = availableSizes[random.nextInt(availableSizes.length)];
      
      // Random listing date (last 30 days)
      final daysAgo = random.nextInt(30);
      final listedDate = DateTime.now().subtract(Duration(days: daysAgo));

      final listing = SellerListing(
        id: _uuid.v4(),
        sellerId: seller['email']!,
        sellerName: seller['name']!,
        originalProduct: shoe,
        condition: condition,
        sellerPrice: sellerPrice,
        selectedSize: selectedSize,
        sellerImages: [shoe.firstPict, shoe.secondPict, shoe.thirdPict],
        conditionNotes: _getRandomConditionNotes(condition, random),
        listedDate: listedDate,
        isActive: random.nextBool() || i < 10, // Most listings are active
        quantity: 1,
      );

      mockListings.add(listing);
    }

    _allListings = mockListings;
    await _saveListings();
  }

  /// Load shoes from assets/data/products.json
  static Future<List<Shoe>> _loadShoesFromAssets() async {
    try {
      // This would normally load from assets, but for demo we'll return empty
      // The actual implementation would use rootBundle.loadString()
      return [];
    } catch (e) {
      print('Error loading shoes: $e');
      return [];
    }
  }

  /// Generate random condition notes
  static String? _getRandomConditionNotes(ProductCondition condition, Random random) {
    final notes = <String, List<String>>{
      'brandNew': [
        'Brand new in box dengan tag',
        'Belum pernah dipakai, kondisi mint',
        'BNIB dengan receipt',
      ],
      'denganBox': [
        'Sedikit creasing normal',
        'Kondisi sangat bagus, jarang dipakai',
        'Box original included',
      ],
      'tanpaBox': [
        'Kondisi bagus, box hilang',
        'Pakai beberapa kali, no box',
        'Good condition tanpa dus',
      ],
      'lainnya': [
        'Ada sedikit noda di sole',
        'Creasing di toe box',
        'Kondisi fair, masih layak pakai',
      ],
    };

    final conditionNotes = notes[condition.name] ?? [];
    if (conditionNotes.isEmpty) return null;
    return conditionNotes[random.nextInt(conditionNotes.length)];
  }

  /// Add a new seller listing
  static Future<bool> addListing(SellerListing listing) async {
    try {
      _allListings.add(listing);
      await _saveListings();
      return true;
    } catch (e) {
      print('Error adding listing: $e');
      return false;
    }
  }

  /// Get all active listings
  static List<SellerListing> getAllActiveListings() {
    return _allListings.where((listing) => listing.isActive).toList()
      ..sort((a, b) => b.listedDate.compareTo(a.listedDate));
  }

  /// Get listings by seller email
  static List<SellerListing> getListingsBySeller(String sellerEmail) {
    return _allListings.where((listing) => 
      listing.sellerId == sellerEmail
    ).toList()
      ..sort((a, b) => b.listedDate.compareTo(a.listedDate));
  }

  /// Get listings by product/shoe
  static List<SellerListing> getListingsByProduct(String productName) {
    return _allListings.where((listing) => 
      listing.originalProduct.name.toLowerCase().contains(productName.toLowerCase()) &&
      listing.isActive
    ).toList()
      ..sort((a, b) => a.sellerPrice.compareTo(b.sellerPrice));
  }

  /// Get featured/popular listings
  static List<SellerListing> getFeaturedListings({int limit = 10}) {
    final featured = _allListings.where((listing) => listing.isActive).toList();
    featured.shuffle();
    return featured.take(limit).toList();
  }

  /// Get recent listings
  static List<SellerListing> getRecentListings({int limit = 10}) {
    return _allListings.where((listing) => listing.isActive).toList()
      ..sort((a, b) => b.listedDate.compareTo(a.listedDate))
      ..take(limit);
  }

  /// Search listings by name and filters
  static List<SellerListing> searchListings({
    String? query,
    ProductCondition? condition,
    double? minPrice,
    double? maxPrice,
    String? size,
    String? brand,
  }) {
    var results = _allListings.where((listing) => listing.isActive);

    if (query != null && query.isNotEmpty) {
      results = results.where((listing) =>
        listing.originalProduct.name.toLowerCase().contains(query.toLowerCase()) ||
        listing.originalProduct.brand.toLowerCase().contains(query.toLowerCase())
      );
    }

    if (condition != null) {
      results = results.where((listing) => listing.condition == condition);
    }

    if (minPrice != null) {
      results = results.where((listing) => listing.sellerPrice >= minPrice);
    }

    if (maxPrice != null) {
      results = results.where((listing) => listing.sellerPrice <= maxPrice);
    }

    if (size != null) {
      results = results.where((listing) => listing.selectedSize == size);
    }

    if (brand != null) {
      results = results.where((listing) => 
        listing.originalProduct.brand.toLowerCase() == brand.toLowerCase()
      );
    }

    return results.toList()..sort((a, b) => a.sellerPrice.compareTo(b.sellerPrice));
  }

  /// Update listing status
  static Future<bool> updateListingStatus(String listingId, bool isActive) async {
    try {
      final index = _allListings.indexWhere((listing) => listing.id == listingId);
      if (index != -1) {
        _allListings[index] = _allListings[index].copyWith(isActive: isActive);
        await _saveListings();
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating listing status: $e');
      return false;
    }
  }

  /// Update listing price
  static Future<bool> updateListingPrice(String listingId, double newPrice) async {
    try {
      final index = _allListings.indexWhere((listing) => listing.id == listingId);
      if (index != -1) {
        // Ensure price doesn't exceed original product price
        final listing = _allListings[index];
        if (newPrice <= listing.originalProduct.price) {
          _allListings[index] = listing.copyWith(sellerPrice: newPrice);
          await _saveListings();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating listing price: $e');
      return false;
    }
  }

  /// Delete a listing
  static Future<bool> deleteListing(String listingId) async {
    try {
      _allListings.removeWhere((listing) => listing.id == listingId);
      await _saveListings();
      return true;
    } catch (e) {
      print('Error deleting listing: $e');
      return false;
    }
  }

  /// Save listings to local storage
  static Future<void> _saveListings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_allListings.map((listing) => listing.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      print('Error saving listings: $e');
    }
  }

  /// Load listings from local storage
  static Future<void> _loadListings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _allListings = jsonList.map((json) => SellerListing.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading listings: $e');
      _allListings = [];
    }
  }

  /// Get statistics for seller dashboard
  static Map<String, dynamic> getSellerStats(String sellerEmail) {
    final userListings = getListingsBySeller(sellerEmail);
    final activeListings = userListings.where((l) => l.isActive).length;
    final totalViews = userListings.fold<int>(0, (sum, listing) => sum + (listing.views ?? 0));
    final totalValue = userListings.fold<double>(0, (sum, listing) => sum + listing.sellerPrice);

    return {
      'totalListings': userListings.length,
      'activeListings': activeListings,
      'totalViews': totalViews,
      'totalValue': totalValue,
      'averagePrice': userListings.isNotEmpty ? totalValue / userListings.length : 0,
    };
  }

  /// Clear all data (for testing/demo)
  static Future<void> clearAllData() async {
    _allListings.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
} 