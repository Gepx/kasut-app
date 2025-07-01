import 'dart:convert';
import 'package:flutter/material.dart';

/// Service responsible for loading brand data following micro-frontend architecture
class BrandLoader extends ChangeNotifier {
  List<String> _brands = [];
  bool _isLoading = true;
  String? _error;

  List<String> get brands => _brands;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load brands from assets
  Future<void> loadBrands(BuildContext context) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Use rootBundle to load the list of assets
      final manifestContent = await DefaultAssetBundle.of(context)
          .loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Use a Set to store unique brand names
      final Set<String> brandNames = {};

      // Filter keys for files within assets/brand-products/
      manifestMap.keys
          .where((String key) {
            return key.startsWith('assets/brand-products/') &&
                !key.endsWith('/');
          })
          .forEach((String key) {
            // Extract the brand name (part after 'assets/brand-products/' and before the next '/')
            final parts = key.split('/');
            if (parts.length > 2) {
              brandNames.add(parts[2]); // Add the brand name to the set
            }
          });

      // Convert the Set to a List, add "All", and sort (optional)
      final List<String> loadedBrands = ["All", ...brandNames];

      _brands = loadedBrands;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error loading brands: $e';
      _isLoading = false;
      // Initialize with a default list if loading fails
      _brands = ["All", "Error Loading Brands"];
      notifyListeners();
    }
  }

  /// Get brands excluding "All"
  List<String> get brandsWithoutAll => 
      _brands.where((brand) => brand != "All").toList();

  /// Check if brand exists
  bool hasBrand(String brand) => _brands.contains(brand);

  /// Clear data
  void clear() {
    _brands = [];
    _isLoading = true;
    _error = null;
    notifyListeners();
  }
} 