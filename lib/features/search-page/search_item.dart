import 'package:flutter/material.dart';
import '../../models/search_model.dart';
import '../../models/shoe_model.dart';
import 'package:intl/intl.dart';
import '../../features/single-product/single_product_page.dart';
import '../../widgets/image_loader.dart';

class SearchPage extends StatefulWidget {
  final bool autoFocus;

  const SearchPage({super.key, this.autoFocus = false});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _showBorder = false;
  List<Shoe> _filteredShoes = [];
  bool _showResults = false;
  List<String> _popularSearches = [];
  List<BrandLogo> _availableBrandLogos = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_showBorder) {
        setState(() => _showBorder = true);
      } else if (_scrollController.offset <= 0 && _showBorder) {
        setState(() => _showBorder = false);
      }
    });

    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }

    _searchController.addListener(_filterShoes);
    _generateDynamicData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterShoes() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredShoes = [];
        _showResults = false;
        return;
      }

      _filteredShoes =
          ShoeData.shoes.where((shoe) {
            final shoeName = shoe.name.toLowerCase();
            final shoeBrand = shoe.brand.toLowerCase();

            // Check for exact matches
            if (shoeName.contains(query) || shoeBrand.contains(query)) {
              return true;
            }

            // Check for similar matches using Levenshtein distance
            final words = query.split(' ');
            return words.any((word) {
              final shoeWords = shoeName.split(' ');
              return shoeWords.any((shoeWord) {
                return _calculateSimilarity(word, shoeWord) > 0.7;
              });
            });
          }).toList();

      _showResults = true;
    });
  }

  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty) return s2.isEmpty ? 1.0 : 0.0;
    if (s2.isEmpty) return 0.0;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0.0),
    );

    for (var i = 0; i <= s1.length; i++) {
      matrix[i][0] = i.toDouble();
    }
    for (var j = 0; j <= s2.length; j++) {
      matrix[0][j] = j.toDouble();
    }

    for (var i = 1; i <= s1.length; i++) {
      for (var j = 1; j <= s2.length; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          matrix[i][j] = matrix[i - 1][j - 1];
        } else {
          matrix[i][j] = 1.0 + matrix[i - 1][j - 1].clamp(0.0, double.infinity);
        }
      }
    }

    final maxLength = s1.length > s2.length ? s1.length : s2.length;
    return 1.0 - (matrix[s1.length][s2.length] / maxLength.toDouble());
  }

  void _generateDynamicData() {
    // Generate popular searches based on available shoes (first 10)
    final shoes = ShoeData.shoes;
    if (shoes.isNotEmpty) {
      final names = shoes.map((s) => s.name).toList();
      _popularSearches = names.take(10).toList();
    } else {
      // Fallback to static list but filter items that exist in dataset
      _popularSearches = SearchData.popularSearches
          .where((name) => ShoeData.shoes.any((s) => s.name.toLowerCase() == name.toLowerCase()))
          .toList();
    }

    // Generate available brand logos based on brands present in shoes
    final availableBrands = ShoeData.shoes.map((s) => s.brand.toLowerCase()).toSet();
    _availableBrandLogos = SearchData.brandLogos
        .where((logo) => availableBrands.contains(logo.name.toLowerCase()))
        .toList();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _showBorder ? Colors.grey[300]! : Colors.transparent,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 35,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search sneakers',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 18,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
        ),
      ),
      body:
          _showResults
              ? _buildSearchResults()
              : SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Popular Search',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                _popularSearches.length >= 5 ? 5 : _popularSearches.length,
                                (index) => _buildSearchItem(index),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                _popularSearches.length > 5 ? _popularSearches.length - 5 : 0,
                                (index) => _buildSearchItem(index + 5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Brand Focus',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBrandGrid(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildSearchResults() {
    if (_filteredShoes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No shoes found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredShoes.length,
      itemBuilder: (context, index) {
        final shoe = _filteredShoes[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(158, 158, 158, 0.4),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleProductPage(shoe: shoe),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AssetImageLoader(
                            imagePath: shoe.firstPict,
                            fit: BoxFit.contain,
                            width: 64,
                            height: 64,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shoe.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shoe.brand,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Rp ${_formatPrice(shoe.price)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  Widget _buildBrandGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: _availableBrandLogos.length,
      itemBuilder: (context, index) {
        final brand = _availableBrandLogos[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    _searchController.text = brand.name;
                    _filterShoes();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(brand.logoPath, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              brand.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (index < _popularSearches.length) {
              _searchController.text = _popularSearches[index];
            }
            _filterShoes();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(index + 1).toString().padLeft(2, '0')}.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  index < _popularSearches.length ? _popularSearches[index] : '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
