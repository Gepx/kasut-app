import 'package:flutter/material.dart';
import 'package:kasut/models/seller_listing_model.dart';

/// Provides seller profile data and manages a list of seller listings.
///
/// Notifies listeners when the seller profile or listings change.
class SellerProvider extends ChangeNotifier {
  Map<String, dynamic>? _profile;
  List<SellerListing> _listings = [];
  double _totalSales = 0.0; // Track actual sales amount

  Map<String, dynamic>? get profile => _profile;
  List<SellerListing> get listings => _listings;
  double get totalSales => _totalSales;

  /// Sets the current seller profile data.
  void setProfile(Map<String, dynamic> data) {
    _profile = data;
    notifyListeners();
  }

  /// Adds a new listing to the list and notifies listeners.
  void addListing(SellerListing listing) {
    _listings.insert(0, listing); // Add to the beginning for recency
    notifyListeners();
  }

  /// Replaces the entire list of listings and notifies listeners.
  void replaceListings(List<SellerListing> newlistings) {
    _listings = newlistings;
    notifyListeners();
  }

  /// Clears all seller data (profile and listings).
  void clearData() {
    _profile = null;
    _listings = [];
    notifyListeners();
  }

  /// Updates an existing listing by ID or adds it if not found.
  void updateListing(SellerListing updatedListing) {
    final index = _listings.indexWhere((l) => l.id == updatedListing.id);
    if (index != -1) {
      _listings[index] = updatedListing;
    } else {
      _listings.add(updatedListing);
    }
    notifyListeners();
  }

  /// Removes a listing by ID.
  void removeListing(String listingId) {
    _listings.removeWhere((l) => l.id == listingId);
    notifyListeners();
  }

  /// Records a sale for a listing
  void recordSale(String listingId, double saleAmount) {
    _totalSales += saleAmount;
    // Optionally remove or mark listing as sold
    final listing = _listings.firstWhere(
      (l) => l.id == listingId,
      orElse: () => throw Exception('Listing not found'),
    );
    removeListing(listingId); // Remove sold listing
    notifyListeners();
  }
}
