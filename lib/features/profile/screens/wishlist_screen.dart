import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:kasut/features/auth/screens/login_screen.dart';
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:kasut/providers/wishlist_provider.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart';
import 'package:kasut/models/shoe_model.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = '/wishlist';

  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool _isLoading = true;
  String _selectedBrand = 'All';
  String _sortBy = 'Name';
  double _minPrice = 0;
  double _maxPrice = 10000000;
  bool _showOnSaleOnly = false;

  final List<String> _sortOptions = ['Name', 'Price: Low to High', 'Price: High to Low', 'Brand'];

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadWishlist();
  }

  Future<void> _checkAuthAndLoadWishlist() async {
    setState(() {
      _isLoading = true;
    });

    // Check if user is logged in
    final currentUser = AuthService.currentUser;
    final isLoggedIn = currentUser != null;

    if (isLoggedIn) {
      // Get user ID (using email as ID)
      final userId = currentUser['email']?.toString() ?? '';

      // Initialize wishlist provider with user ID
      await Provider.of<WishlistProvider>(
        context,
        listen: false,
      ).initializeWithUser(userId);
    }

    setState(() {
      _isLoading = false;
    });
  }

  List<Shoe> _getFilteredAndSortedItems(List<Shoe> items) {
    // Filter by brand
    List<Shoe> filtered = items;
    if (_selectedBrand != 'All') {
      filtered = filtered.where((shoe) => shoe.brand == _selectedBrand).toList();
    }

    // Filter by price range
    filtered = filtered.where((shoe) {
      final price = shoe.discountPrice ?? shoe.price;
      return price >= _minPrice && price <= _maxPrice;
    }).toList();

    // Filter by sale status
    if (_showOnSaleOnly) {
      filtered = filtered.where((shoe) => shoe.discountPrice != null).toList();
    }

    // Sort items
    switch (_sortBy) {
      case 'Name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Price: Low to High':
        filtered.sort((a, b) {
          final priceA = a.discountPrice ?? a.price;
          final priceB = b.discountPrice ?? b.price;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) {
          final priceA = a.discountPrice ?? a.price;
          final priceB = b.discountPrice ?? b.price;
          return priceB.compareTo(priceA);
        });
        break;
      case 'Brand':
        filtered.sort((a, b) => a.brand.compareTo(b.brand));
        break;
    }

    return filtered;
  }

  List<String> _getAvailableBrands(List<Shoe> items) {
    final brands = items.map((shoe) => shoe.brand).toSet().toList()..sort();
    return ['All', ...brands];
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final allItems = wishlistProvider.getWishlistItems();
              final availableBrands = _getAvailableBrands(allItems);
              
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Title
                    const Text(
                      'Filter & Sort',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand filter
                            _buildFilterSection(
                              'Brand',
                              DropdownButton<String>(
                                value: _selectedBrand,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                items: availableBrands
                                    .map((brand) => DropdownMenuItem(
                                          value: brand,
                                          child: Text(brand),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setModalState(() {
                                    _selectedBrand = value!;
                                  });
                                },
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Sort options
                            _buildFilterSection(
                              'Sort by',
                              DropdownButton<String>(
                                value: _sortBy,
                                isExpanded: true,
                                style: const TextStyle(color: Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.black,
                                ),
                                items: _sortOptions
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setModalState(() {
                                    _sortBy = value!;
                                  });
                                },
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Price range
                            _buildFilterSection(
                              'Price Range',
                              Column(
                                children: [
                                  RangeSlider(
                                    values: RangeValues(_minPrice, _maxPrice),
                                    min: 0,
                                    max: 10000000,
                                    divisions: 100,
                                    activeColor: Colors.black,
                                    inactiveColor: Colors.grey[300],
                                    labels: RangeLabels(
                                      'IDR ${(_minPrice / 1000000).toStringAsFixed(1)}M',
                                      'IDR ${(_maxPrice / 1000000).toStringAsFixed(1)}M',
                                    ),
                                    onChanged: (values) {
                                      setModalState(() {
                                        _minPrice = values.start;
                                        _maxPrice = values.end;
                                      });
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'IDR ${(_minPrice / 1000000).toStringAsFixed(1)}M',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                      Text(
                                        'IDR ${(_maxPrice / 1000000).toStringAsFixed(1)}M',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Show on sale only
                            _buildFilterSection(
                              'Special Filters',
                              CheckboxListTile(
                                title: const Text(
                                  'Show only items on sale',
                                  style: TextStyle(color: Colors.black),
                                ),
                                value: _showOnSaleOnly,
                                activeColor: Colors.black,
                                onChanged: (value) {
                                  setModalState(() {
                                    _showOnSaleOnly = value!;
                                  });
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Apply button
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Reset filters
                              setModalState(() {
                                _selectedBrand = 'All';
                                _sortBy = 'Name';
                                _minPrice = 0;
                                _maxPrice = 10000000;
                                _showOnSaleOnly = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(color: Colors.black),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Apply filters
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                            ),
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    // Check if user is logged in
    final isLoggedIn = AuthService.currentUser != null;

    if (!isLoggedIn) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'Please log in to view your wishlist.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.routeName).then((_) {
                  _checkAuthAndLoadWishlist();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                elevation: 0,
              ),
              child: const Text('Log In'),
            ),
          ],
        ),
      );
    }

    // Use Consumer to listen to wishlist changes
    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final allWishlistItems = wishlistProvider.getWishlistItems();
        final filteredItems = _getFilteredAndSortedItems(allWishlistItems);

        if (allWishlistItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your wishlist is empty.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add items to your wishlist to see them here.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'No items match your filters.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters to see more items.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedBrand = 'All';
                      _sortBy = 'Name';
                      _minPrice = 0;
                      _maxPrice = 10000000;
                      _showOnSaleOnly = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          );
        }

        // Show filter summary if filters are applied
        final hasActiveFilters = _selectedBrand != 'All' || 
                                 _showOnSaleOnly || 
                                 _minPrice > 0 || 
                                 _maxPrice < 10000000;

        return Column(
          children: [
            if (hasActiveFilters)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Showing ${filteredItems.length} of ${allWishlistItems.length} items',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedBrand = 'All';
                          _sortBy = 'Name';
                          _minPrice = 0;
                          _maxPrice = 10000000;
                          _showOnSaleOnly = false;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate number of columns based on screen width
                  int crossAxisCount = 2; // Default for mobile

                  if (constraints.maxWidth > 600) {
                    crossAxisCount = 3; // Tablet
                  }
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4; // Desktop
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final shoe = filteredItems[index];
                      return Stack(
                        children: [
                          // Use the SneakerCard widget
                          SneakerCard(
                            sneaker: shoe,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleProductPage(shoe: shoe),
                                ),
                              );
                            },
                          ),
                          // Remove button overlay
                          Positioned(
                            top: 8,
                            left: 8,
                            child: InkWell(
                              onTap: () {
                                wishlistProvider.toggleWishlist(shoe.sku);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
