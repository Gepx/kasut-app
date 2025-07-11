import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:kasut/providers/seller_provider.dart';
import 'package:kasut/features/seller/add_listing_screen.dart';
import 'package:kasut/models/seller_listing_model.dart';
import 'package:kasut/services/seller_listing_service.dart';

class SellingScreen extends StatelessWidget {
  static const String routeName = '/selling';

  const SellingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Products', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.black, width: 1)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Listing',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddListingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<SellerProvider>(
        builder: (context, provider, child) {
          if (provider.listings.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.listings.length,
            itemBuilder: (context, index) {
              final listing = provider.listings[index];
              return _ListingCard(listing: listing);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 24),
          const Text(
            'No Products Yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first product.',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add New Listing'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddListingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final SellerListing listing;
  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                listing.originalProduct.firstPict,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder:
                    (ctx, err, st) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.originalProduct.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${listing.conditionText} • Size ${listing.selectedSize}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fmt.format(listing.sellerPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          _StatusPill(isActive: listing.isActive),
                          const SizedBox(width: 8),
                          PopupMenuButton<String>(
                            onSelected:
                                (value) =>
                                    _handleMenuAction(context, value, listing),
                            itemBuilder:
                                (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            icon: const Icon(Icons.more_vert, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(
    BuildContext context,
    String action,
    SellerListing listing,
  ) {
    final sellerProvider = Provider.of<SellerProvider>(context, listen: false);

    switch (action) {
      case 'edit':
        _showEditDialog(context, listing, sellerProvider);
        break;
      case 'delete':
        _showDeleteDialog(context, listing, sellerProvider);
        break;
    }
  }

  void _showEditDialog(
    BuildContext context,
    SellerListing listing,
    SellerProvider provider,
  ) {
    final nameController = TextEditingController(
      text: listing.originalProduct.name,
    );
    final priceController = TextEditingController(
      text: listing.sellerPrice.toString(),
    );
    bool isActive = listing.isActive;
    String? selectedImagePath;

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Edit Product'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Product Image Section
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                selectedImagePath != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        selectedImagePath!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        listing.originalProduct.firstPict,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed:
                                () =>
                                    _showImagePicker(context, setState, (path) {
                                      selectedImagePath = path;
                                    }),
                            icon: const Icon(Icons.camera_alt, size: 16),
                            label: const Text('Change Image'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.black87,
                              elevation: 0,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Product Name Field
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Product Name',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),

                          // Price Field
                          TextField(
                            controller: priceController,
                            decoration: const InputDecoration(
                              labelText: 'Price',
                              prefixText: 'Rp ',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Active Status
                          Row(
                            children: [
                              Checkbox(
                                value: isActive,
                                onChanged:
                                    (value) => setState(
                                      () => isActive = value ?? false,
                                    ),
                              ),
                              const Text('Active'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final newPrice = double.tryParse(priceController.text);
                        final newName = nameController.text.trim();

                        if (newPrice != null && newName.isNotEmpty) {
                          // Create updated shoe with new name and image
                          final updatedShoe = listing.originalProduct.copyWith(
                            name: newName,
                            firstPict:
                                selectedImagePath ??
                                listing.originalProduct.firstPict,
                          );

                          final updatedListing = listing.copyWith(
                            originalProduct: updatedShoe,
                            sellerPrice: newPrice,
                            isActive: isActive,
                          );

                          provider.updateListing(updatedListing);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product updated successfully'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all required fields'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _showImagePicker(
    BuildContext context,
    StateSetter setState,
    Function(String) onImageSelected,
  ) {
    // Sample shoe images available in the app
    final availableImages = [
      'assets/brand-products/Adidas/Adidas Handball Spezial Light Sky Blue Gum (Women\'s) - 1.png',
      'assets/brand-products/Air Jordan/Air Jordan 1 Low Black White Grey - 1.png',
      'assets/brand-products/Asics/ASICS Gel Kayano 14 Birch Pure Silver - 1.png',
      'assets/brand-products/New Balance/New Balance 1906R Black Metallic Silver - 1.png',
      'assets/brand-products/nike/Nike Air Force 1 Low \'07 Triple White (2021) - 1.png',
      'assets/brand-products/OnClouds/ON CLOUDTILT Ultramarine Eclipse - 1.png',
      'assets/brand-products/Puma/PUMA All Pro Nitro Bold Blue Koral Ice - 1.png',
      'assets/brand-products/Salomon/Salomon XT 6 Plum Kitten India Ink - 1.png',
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Choose Product Image'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: availableImages.length,
                itemBuilder: (context, index) {
                  final imagePath = availableImages[index];
                  return GestureDetector(
                    onTap: () {
                      onImageSelected(imagePath);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image_not_supported),
                              ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    SellerListing listing,
    SellerProvider provider,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: Text(
              'Are you sure you want to delete "${listing.originalProduct.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  provider.removeListing(listing.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool isActive;
  const _StatusPill({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}
