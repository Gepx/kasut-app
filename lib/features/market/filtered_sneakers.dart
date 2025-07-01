import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart';

class FilteredSneakersPage extends StatefulWidget {
  final List<Shoe> filteredShoes;
  final Set<String> selectedTags;
  final Set<String> selectedGenders;
  final Map<String, Set<String>> selectedSizes;
  final String selectedBrand;

  const FilteredSneakersPage({
    super.key,
    required this.filteredShoes,
    required this.selectedTags,
    required this.selectedGenders,
    required this.selectedSizes,
    required this.selectedBrand,
  });

  @override
  State<FilteredSneakersPage> createState() => _FilteredSneakersPageState();
}

class _FilteredSneakersPageState extends State<FilteredSneakersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Filtered Results (${widget.filteredShoes.length})',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.black),
            onPressed: () {
              // Navigate back to market page with filters preserved
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filters display
          if (widget.selectedTags.isNotEmpty ||
              widget.selectedGenders.isNotEmpty ||
              widget.selectedSizes.values.any((sizes) => sizes.isNotEmpty))
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Active Filters:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Navigate back to market page to clear filters
                          Navigator.pop(context);
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildActiveFilters(),
                ],
              ),
            ),

          // Results count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  '${widget.filteredShoes.length} results found',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                if (widget.selectedBrand != "All") ...[
                  const SizedBox(width: 8),
                  Text(
                    'for ${widget.selectedBrand}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),

          // Grid of filtered shoes
          Expanded(
            child:
                widget.filteredShoes.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No Product Found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Update Filters'),
                          ),
                        ],
                      ),
                    )
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          // Calculate number of columns based on available width
                          int crossAxisCount = 2; // Default for phones
                          double childAspectRatio = 0.7;

                          // Responsive grid layout based on screen width
                          if (constraints.maxWidth > 600 &&
                              constraints.maxWidth < 900) {
                            crossAxisCount = 4; // Tablets
                            childAspectRatio = 0.65;
                          } else if (constraints.maxWidth >= 900) {
                            crossAxisCount = 8; // Desktops
                            childAspectRatio = 0.6;
                          }

                          return GridView.builder(
                            itemCount: widget.filteredShoes.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: childAspectRatio,
                                ),
                            itemBuilder: (context, index) {
                              final shoe = widget.filteredShoes[index];
                              return SneakerCard(
                                sneaker: shoe,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              SingleProductPage(shoe: shoe),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Widget to display active filters with option to remove them
  Widget _buildActiveFilters() {
    List<Widget> filterChips = [];

    // Add tag filters
    for (var tag in widget.selectedTags) {
      filterChips.add(
        _buildFilterChip(tag, () {
          // This would need to be handled by the parent market page
          // For now, just show the chip as non-removable
        }),
      );
    }

    // Add gender filters
    for (var gender in widget.selectedGenders) {
      filterChips.add(
        _buildFilterChip(
          gender == 'men'
              ? 'Men'
              : gender == 'women'
              ? 'Women'
              : 'Kids',
          () {
            // This would need to be handled by the parent market page
          },
        ),
      );
    }

    // Add size filters
    for (var gender in widget.selectedSizes.keys) {
      for (var size in widget.selectedSizes[gender]!) {
        filterChips.add(
          _buildFilterChip(
            '${gender == 'men'
                ? 'Men'
                : gender == 'women'
                ? 'Women'
                : 'Kids'} $size',
            () {
              // This would need to be handled by the parent market page
            },
          ),
        );
      }
    }

    return Wrap(spacing: 8, runSpacing: 8, children: filterChips);
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: Colors.grey[200],
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: onRemove,
    );
  }
}
