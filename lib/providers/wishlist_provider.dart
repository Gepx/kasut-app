import 'package:flutter/foundation.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  // Set to store SKUs of wishlist items
  final Set<String> _wishlistSkus = {};
  bool _isLoading = false;
  String? _currentUserId;

  // Getter for wishlist items
  Set<String> get wishlistSkus => _wishlistSkus;
  
  // Getter for loading state
  bool get isLoading => _isLoading;
  
  // Getter for current user ID
  String? get currentUserId => _currentUserId;

  // Check if a shoe is in the wishlist
  bool isInWishlist(String sku) {
    return _wishlistSkus.contains(sku);
  }

  // Get wishlist count
  int get wishlistCount => _wishlistSkus.length;

  // Toggle wishlist status
  void toggleWishlist(String sku) {
    if (_wishlistSkus.contains(sku)) {
      _wishlistSkus.remove(sku);
    } else {
      _wishlistSkus.add(sku);
    }
    _saveWishlist(); // Save changes to persistent storage
    notifyListeners(); // Notify listeners about the change
  }

  // Add item to wishlist
  void addToWishlist(String sku) {
    if (!_wishlistSkus.contains(sku)) {
      _wishlistSkus.add(sku);
      _saveWishlist();
      notifyListeners();
    }
  }

  // Remove item from wishlist
  void removeFromWishlist(String sku) {
    if (_wishlistSkus.contains(sku)) {
      _wishlistSkus.remove(sku);
      _saveWishlist();
      notifyListeners();
    }
  }

  // Get wishlist items as Shoe objects
  List<Shoe> getWishlistItems() {
    try {
      return ShoeData.shoes
          .where((shoe) => _wishlistSkus.contains(shoe.sku))
          .toList();
    } catch (e) {
      print('Error getting wishlist items: $e');
      return [];
    }
  }

  // Get wishlist items by brand
  List<Shoe> getWishlistItemsByBrand(String brand) {
    try {
      final allItems = getWishlistItems();
      if (brand.toLowerCase() == 'all') {
        return allItems;
      }
      return allItems.where((shoe) => shoe.brand.toLowerCase() == brand.toLowerCase()).toList();
    } catch (e) {
      print('Error getting wishlist items by brand: $e');
      return [];
    }
  }

  // Get wishlist items on sale
  List<Shoe> getWishlistItemsOnSale() {
    try {
      return getWishlistItems().where((shoe) => shoe.discountPrice != null).toList();
    } catch (e) {
      print('Error getting wishlist items on sale: $e');
      return [];
    }
  }

  // Check if wishlist has items from a specific brand
  bool hasItemsFromBrand(String brand) {
    return getWishlistItemsByBrand(brand).isNotEmpty;
  }

  // Load wishlist from SharedPreferences
  Future<void> loadWishlist() async {
    if (_currentUserId == null) return;
    
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final List<String>? wishlist = prefs.getStringList('wishlist_$_currentUserId');
      
      if (wishlist != null) {
        _wishlistSkus.clear();
        _wishlistSkus.addAll(wishlist);
      }
    } catch (e) {
      print('Error loading wishlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save wishlist to SharedPreferences
  Future<void> _saveWishlist() async {
    if (_currentUserId == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('wishlist_$_currentUserId', _wishlistSkus.toList());
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }

  // Initialize wishlist with user ID
  Future<void> initializeWithUser(String userId) async {
    try {
      _currentUserId = userId;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      
      await loadWishlist();
    } catch (e) {
      print('Error initializing wishlist: $e');
    }
  }

  // Clear wishlist (for logout)
  Future<void> clearWishlist() async {
    try {
      _wishlistSkus.clear();
      _currentUserId = null;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      // Note: We don't remove the saved wishlist data in case user logs back in
      
      notifyListeners();
    } catch (e) {
      print('Error clearing wishlist: $e');
    }
  }

  // Sync wishlist with server (placeholder for future implementation)
  Future<void> syncWithServer() async {
    // TODO: Implement server sync when backend is available
    try {
      // This would sync local wishlist with server data
      print('Syncing wishlist with server...');
    } catch (e) {
      print('Error syncing wishlist: $e');
    }
  }

  // Import wishlist from another source
  Future<void> importWishlist(List<String> skus) async {
    try {
      _wishlistSkus.clear();
      _wishlistSkus.addAll(skus);
      await _saveWishlist();
      notifyListeners();
    } catch (e) {
      print('Error importing wishlist: $e');
    }
  }

  // Export wishlist
  List<String> exportWishlist() {
    return _wishlistSkus.toList();
  }

  // Get wishlist summary for analytics
  Map<String, dynamic> getWishlistSummary() {
    try {
      final items = getWishlistItems();
      final brands = items.map((shoe) => shoe.brand).toSet();
      final totalValue = items.fold<double>(0, (sum, shoe) => sum + (shoe.discountPrice ?? shoe.price));
      final onSaleCount = items.where((shoe) => shoe.discountPrice != null).length;
      
      return {
        'totalItems': items.length,
        'totalBrands': brands.length,
        'totalValue': totalValue,
        'onSaleItems': onSaleCount,
        'brands': brands.toList(),
      };
    } catch (e) {
      print('Error getting wishlist summary: $e');
      return {
        'totalItems': 0,
        'totalBrands': 0,
        'totalValue': 0.0,
        'onSaleItems': 0,
        'brands': <String>[],
      };
    }
  }
}
