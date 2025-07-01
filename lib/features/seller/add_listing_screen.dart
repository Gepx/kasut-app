import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/models/seller_listing_model.dart';
import 'package:kasut/services/seller_listing_service.dart';
import 'package:kasut/utils/indonesian_utils.dart';
import 'package:kasut/utils/responsive_utils.dart';
import 'package:kasut/features/auth/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _searchController = TextEditingController();

  Shoe? _selectedProduct;
  ProductCondition _selectedCondition = ProductCondition.brandNew;
  String? _selectedSize;
  List<Uint8List> _uploadedImages = [];
  List<Shoe> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _priceController.dispose();
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final results = ShoeData.shoes.where((shoe) {
        final lowerQuery = query.toLowerCase();
        return shoe.name.toLowerCase().contains(lowerQuery) ||
               shoe.brand.toLowerCase().contains(lowerQuery);
      }).take(10).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _selectProduct(Shoe product) {
    setState(() {
      _selectedProduct = product;
      _selectedSize = null; // Reset size selection
      _searchController.clear();
      _searchResults = [];
      
      // Set suggested price (80% of original for used items)
      if (_selectedCondition != ProductCondition.brandNew) {
        _priceController.text = (product.price * 0.8).round().toString();
      } else {
        _priceController.text = product.price.round().toString();
      }
    });
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      final images = result.files
          .where((file) => file.bytes != null)
          .map((file) => file.bytes!)
          .toList();
      
      setState(() {
        _uploadedImages.addAll(images);
        // Limit to 5 images
        if (_uploadedImages.length > 5) {
          _uploadedImages = _uploadedImages.take(5).toList();
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _uploadedImages.removeAt(index);
    });
  }

  bool _validatePrice() {
    if (_selectedProduct == null) return false;
    
    final price = double.tryParse(_priceController.text);
    if (price == null) return false;
    
    return price <= _selectedProduct!.price;
  }

  void _submitListing() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      _showError('Pilih produk terlebih dahulu');
      return;
    }
    if (_selectedSize == null) {
      _showError('Pilih ukuran terlebih dahulu');
      return;
    }
    if (_uploadedImages.isEmpty) {
      _showError('Upload minimal 1 foto');
      return;
    }
    if (!_validatePrice()) {
      _showError(IndonesianText.maksHarga);
      return;
    }

    final currentUser = AuthService.currentUser;
    if (currentUser == null) {
      _showError('Anda harus login terlebih dahulu');
      return;
    }

    // Create seller listing
    final listing = SellerListing(
      id: const Uuid().v4(),
      sellerId: currentUser['email'],
      sellerName: currentUser['username'] ?? 'Anonymous',
      originalProduct: _selectedProduct!,
      condition: _selectedCondition,
      sellerPrice: double.parse(_priceController.text),
      selectedSize: _selectedSize!,
      sellerImages: _uploadedImages.map((bytes) => 'data:image/jpeg;base64,${bytes.toString()}').toList(),
      conditionNotes: _notesController.text.isEmpty ? null : _notesController.text,
      listedDate: DateTime.now(),
    );

    // Add to service
    SellerListingService.addListing(listing);

    // Show success and go back
    _showSuccess('Produk berhasil dijual!');
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, width) {
        final padding = ResponsiveUtils.getResponsivePadding(width);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(IndonesianText.jualSepatu),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Selection
                  _buildSectionTitle(IndonesianText.pilihProduk),
                  if (_selectedProduct == null) ...[
                    _buildProductSearch(),
                    if (_searchResults.isNotEmpty) _buildSearchResults(),
                  ] else
                    _buildSelectedProduct(),
                  
                  SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.lg)),
                  
                  // Size Selection
                  if (_selectedProduct != null) ...[
                    _buildSectionTitle(IndonesianText.ukuran),
                    _buildSizeSelection(),
                    SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.lg)),
                  ],
                  
                  // Condition Selection
                  _buildSectionTitle(IndonesianText.kondisi),
                  _buildConditionSelection(),
                  SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.lg)),
                  
                  // Image Upload
                  _buildSectionTitle(IndonesianText.uploadFoto),
                  _buildImageUpload(),
                  SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.lg)),
                  
                  // Price Setting
                  _buildSectionTitle(IndonesianText.tentukanharga),
                  _buildPriceInput(width),
                  SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.lg)),
                  
                  // Condition Notes
                  _buildSectionTitle(IndonesianText.catatanKondisi),
                  _buildNotesInput(),
                  SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.xl)),
                  
                  // Submit Button
                  _buildSubmitButton(width),
                  SizedBox(height: ResponsiveUtils.getSpacing(width, SpacingSize.lg)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildProductSearch() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '${IndonesianText.cari} sepatu...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          onChanged: _searchProducts,
        ),
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final product = _searchResults[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                product.firstPict,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      width: 40,
                      height: 40,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${product.brand} • ${IndonesianUtils.formatRupiahShort(product.price)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            onTap: () => _selectProduct(product),
          );
        },
      ),
    );
  }

  Widget _buildSelectedProduct() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
        color: Colors.green[50],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              _selectedProduct!.firstPict,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedProduct!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _selectedProduct!.brand,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Harga Brand New: ${IndonesianUtils.formatRupiahShort(_selectedProduct!.price)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _selectedProduct = null),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelection() {
    if (_selectedProduct == null) return const SizedBox();
    
    final availableSizes = <String>[];
    _selectedProduct!.sizes.forEach((gender, sizes) {
      availableSizes.addAll(sizes.map((size) => size.toString()));
    });

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: availableSizes.map((size) {
        final isSelected = _selectedSize == size;
        return GestureDetector(
          onTap: () => setState(() => _selectedSize = size),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildConditionSelection() {
    return Column(
      children: ProductCondition.values.map((condition) {
        return RadioListTile<ProductCondition>(
          value: condition,
          groupValue: _selectedCondition,
          activeColor: Colors.black,
          onChanged: (value) => setState(() {
            _selectedCondition = value!;
            // Adjust suggested price based on condition
            if (_selectedProduct != null) {
              double suggestionMultiplier = 1.0;
              switch (condition) {
                case ProductCondition.brandNew:
                  suggestionMultiplier = 1.0;
                  break;
                case ProductCondition.denganBox:
                  suggestionMultiplier = 0.85;
                  break;
                case ProductCondition.tanpaBox:
                  suggestionMultiplier = 0.75;
                  break;
                case ProductCondition.lainnya:
                  suggestionMultiplier = 0.7;
                  break;
              }
              _priceController.text = (_selectedProduct!.price * suggestionMultiplier).round().toString();
            }
          }),
          title: Text(condition.label),
          dense: true,
        );
      }).toList(),
    );
  }

  Widget _buildImageUpload() {
    return Column(
      children: [
        if (_uploadedImages.isNotEmpty)
          Container(
            height: 100,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _uploadedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          _uploadedImages[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        OutlinedButton.icon(
          onPressed: _uploadedImages.length < 5 ? _pickImages : null,
          icon: const Icon(Icons.add_photo_alternate),
          label: Text(_uploadedImages.isEmpty 
              ? IndonesianText.uploadFoto 
              : 'Tambah Foto (${_uploadedImages.length}/5)'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInput(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: '${IndonesianText.harga} (Rp)',
            hintText: 'Masukkan harga jual',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixText: 'Rp ',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harga harus diisi';
            }
            final price = double.tryParse(value);
            if (price == null || price <= 0) {
              return 'Harga tidak valid';
            }
            if (_selectedProduct != null && price > _selectedProduct!.price) {
              return IndonesianText.maksHarga;
            }
            return null;
          },
        ),
        if (_selectedProduct != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'Harga Brand New: ${IndonesianUtils.formatRupiah(_selectedProduct!.price)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotesInput() {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Catatan Kondisi (Opsional)',
        hintText: 'Jelaskan kondisi detail sepatu Anda...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildSubmitButton(double width) {
    return SizedBox(
      width: double.infinity,
      height: ResponsiveUtils.getButtonHeight(width),
      child: ElevatedButton(
        onPressed: _submitListing,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          IndonesianText.jual,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
} 