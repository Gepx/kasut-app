import 'package:flutter/foundation.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  // Set to store SKUs of wishlist items
  final Set<String> _wishlistSkus = {};

  // Getter for wishlist items
  Set<String> get wishlistSkus => _wishlistSkus;

  // Check if a shoe is in the wishlist
  bool isInWishlist(String sku) {
    return _wishlistSkus.contains(sku);
  }

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

  // Get wishlist items as Shoe objects
  List<Shoe> getWishlistItems() {
    return ShoeData.shoes
        .where((shoe) => _wishlistSkus.contains(shoe.sku))
        .toList();
  }

  // Load wishlist from SharedPreferences
  Future<void> loadWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');

      if (userId != null) {
        final List<String>? wishlist = prefs.getStringList('wishlist_$userId');
        if (wishlist != null) {
          _wishlistSkus.clear();
          _wishlistSkus.addAll(wishlist);
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading wishlist: $e');
    }
  }

  // Save wishlist to SharedPreferences
  Future<void> _saveWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('user_id');

      if (userId != null) {
        await prefs.setStringList('wishlist_$userId', _wishlistSkus.toList());
      }
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }

  // Initialize wishlist with user ID
  Future<void> initializeWithUser(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId);
      await loadWishlist();
    } catch (e) {
      print('Error initializing wishlist: $e');
    }
  }

  // Clear wishlist (for logout)
  void clearWishlist() {
    _wishlistSkus.clear();
    notifyListeners();
  }
}
