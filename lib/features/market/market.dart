import 'package:flutter/material.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/home/home_search_bar.dart';

// Define the list of brands
final List<String> _brands = [
  "All",
  "Air Jordan",
  "Adidas",
  "onCloud",
  "Nike",
  "Puma",
  "New Balance",
  "Asics",
  "Salomon",
  "Ortuseight",
  "Mizuno",
  "Under Armour",
  "Specs",
  "Yeezy",
];

// MarketAppBar class in the same file
class MarketAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> brands; // Add brands parameter

  const MarketAppBar({
    super.key,
    required this.tabController,
    required this.brands, // Require brands
  });

  @override
  Size get preferredSize => const Size.fromHeight(135); // Adjust height if needed

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80, // Keep existing structure
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20), // Adjust spacing as needed
              Row(
                children: [
                  const Expanded(child: HomeSearchBar()), // Keep search bar
                  IconButton(
                    // Use IconButton for better semantics
                    icon: const Icon(Icons.filter_alt_outlined, size: 25),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (context) => const FilterModal(),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(35), // Height for the TabBar
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 0.1),
            ),
          ),
          child: LayoutBuilder(
            // Use LayoutBuilder for responsive padding
            builder: (context, constraints) {
              final isDesktop =
                  constraints.maxWidth >= 900; // Determine if desktop

              return TabBar(
                isScrollable: true,
                tabAlignment:
                    isDesktop
                        ? TabAlignment.center
                        : TabAlignment.start, // Align tabs
                controller: tabController, // Use passed controller
                labelStyle: const TextStyle(
                  fontSize: 12, // Increased font size for better readability
                  fontWeight: FontWeight.bold,
                ),
                // Generate tabs dynamically from the brands list
                tabs: brands.map((brand) => Tab(text: brand)).toList(),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(
                  horizontal:
                      isDesktop ? 24.0 : 8.0, // Increased mobile padding
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MarketScreen extends StatefulWidget {
  final TabController tabController;
  final List<String> brands; // Add brands parameter

  const MarketScreen({
    super.key,
    required this.tabController,
    required this.brands,
  }); // Require brands

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Shoe> filteredShoes = [];

  // Filter state
  Set<String> selectedConditions = {};
  Set<String> selectedGenders = {};
  Map<String, Set<String>> selectedSizes = {'Men': {}, 'Women': {}, 'Kids': {}};

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabChange);
    _filterShoes(); // initial load
  }

  void _handleTabChange() {
    if (!widget.tabController.indexIsChanging) {
      _filterShoes();
    }
  }

  void _filterShoes() {
    if (widget.brands.isEmpty) {
      // Handle case where brands are not yet loaded
      setState(() {
        filteredShoes = [];
      });
      return;
    }
    final selectedBrand =
        widget.brands[widget.tabController.index]; // Use widget.brands

    // Get all shoes or filter by brand
    List<Shoe> brandFilteredShoes;
    if (selectedBrand == "All") {
      brandFilteredShoes = ShoeData.shoes;
    } else {
      brandFilteredShoes = ShoeData.getByBrand(selectedBrand);
    }

    // Apply additional filters (condition, gender, size)
    setState(() {
      filteredShoes = _applyFilters(brandFilteredShoes);

      // Debug print to check results
      print(
        'Filtered ${filteredShoes.length} shoes for brand: $selectedBrand with additional filters',
      );
    });
  }

  // Apply all selected filters to the shoes
  List<Shoe> _applyFilters(List<Shoe> shoes) {
    // If no filters are selected, return all shoes
    if (selectedConditions.isEmpty &&
        selectedGenders.isEmpty &&
        selectedSizes.values.every((sizes) => sizes.isEmpty)) {
      return shoes;
    }

    return shoes.where((shoe) {
      // Filter by condition if any conditions are selected
      if (selectedConditions.isNotEmpty) {
        // Assuming shoe has a condition property
        // If not, you'll need to adjust this logic
        if (!selectedConditions.contains(shoe.condition)) {
          return false;
        }
      }

      // Filter by gender if any genders are selected
      if (selectedGenders.isNotEmpty) {
        // Assuming shoe has a gender property
        // If not, you'll need to adjust this logic
        if (!selectedGenders.contains(shoe.gender)) {
          return false;
        }
      }

      // Filter by size if any sizes are selected
      bool sizeMatch = true;
      if (selectedSizes.values.any((sizes) => sizes.isNotEmpty)) {
        sizeMatch = false;

        // Check if any selected size matches the shoe's available sizes
        for (var gender in selectedSizes.keys) {
          if (selectedSizes[gender]!.isNotEmpty) {
            // Assuming shoe has availableSizes property
            // If not, you'll need to adjust this logic
            for (var size in selectedSizes[gender]!) {
              if (shoe.availableSizes.contains('$gender-$size')) {
                sizeMatch = true;
                break;
              }
            }
            if (sizeMatch) break;
          }
        }
      }

      return sizeMatch;
    }).toList();
  }

  // Method to update filters from FilterModal
  void updateFilters({
    required Set<String> conditions,
    required Set<String> genders,
    required Map<String, Set<String>> sizes,
  }) {
    setState(() {
      selectedConditions = conditions;
      selectedGenders = genders;
      selectedSizes = sizes;
      _filterShoes(); // Re-apply filters
    });
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate number of columns based on available width
          int crossAxisCount = 2; // Default for phones
          double childAspectRatio = 0.7;

          // Responsive grid layout based on screen width
          if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
            crossAxisCount = 4; // Tablets
            childAspectRatio = 0.65;
          } else if (constraints.maxWidth >= 900) {
            crossAxisCount = 8; // Desktops - increased to 8 columns
            childAspectRatio = 0.6;
          }

          return Column(
            children: [
              // Active filters display
              if (selectedConditions.isNotEmpty ||
                  selectedGenders.isNotEmpty ||
                  selectedSizes.values.any((sizes) => sizes.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildActiveFilters(),
                ),

              // Grid of shoes
              Expanded(
                child:
                    filteredShoes.isEmpty
                        ? const Center(
                          child: Text('No shoes match your filters'),
                        )
                        : GridView.builder(
                          itemCount: filteredShoes.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: childAspectRatio,
                              ),
                          itemBuilder: (context, index) {
                            final shoe = filteredShoes[index];
                            return SneakerCard(sneaker: shoe);
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget to display active filters with option to remove them
  Widget _buildActiveFilters() {
    List<Widget> filterChips = [];

    // Add condition filters
    for (var condition in selectedConditions) {
      filterChips.add(
        _buildFilterChip(condition, () {
          setState(() {
            selectedConditions.remove(condition);
            _filterShoes();
          });
        }),
      );
    }

    // Add gender filters
    for (var gender in selectedGenders) {
      filterChips.add(
        _buildFilterChip(gender, () {
          setState(() {
            selectedGenders.remove(gender);
            _filterShoes();
          });
        }),
      );
    }

    // Add size filters
    for (var gender in selectedSizes.keys) {
      for (var size in selectedSizes[gender]!) {
        filterChips.add(
          _buildFilterChip('$gender $size', () {
            setState(() {
              selectedSizes[gender]!.remove(size);
              _filterShoes();
            });
          }),
        );
      }
    }

    // Add clear all option if there are filters
    if (filterChips.isNotEmpty) {
      filterChips.add(
        TextButton(
          onPressed: () {
            setState(() {
              selectedConditions.clear();
              selectedGenders.clear();
              for (var gender in selectedSizes.keys) {
                selectedSizes[gender]!.clear();
              }
              _filterShoes();
            });
          },
          child: const Text('Clear All'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: filterChips),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
      ),
    );
  }
}

// Helper to normalize brand names for filtering (can reuse from ShoeData if accessible)
String _normalizeBrandName(String brand) {
  // Remove spaces, convert to lowercase
  String normalized = brand.toLowerCase().replaceAll(' ', '');

  // Handle special cases (should match logic in ShoeData)
  if (normalized == 'oncloud' || normalized == 'on') {
    return 'OnClouds'.toLowerCase().replaceAll(
      ' ',
      '',
    ); // Normalize to match JSON
  }

  if (normalized == 'airjordan' || normalized == 'jordan') {
    return 'Air Jordan'.toLowerCase().replaceAll(
      ' ',
      '',
    ); // Normalize to match JSON
  }

  if (normalized == 'onitsukatiger') {
    return 'Onisutka Tiger'.toLowerCase().replaceAll(
      ' ',
      '',
    ); // Normalize to match JSON
  }

  if (normalized == 'newbalance' || normalized == 'nb') {
    return 'New Balance'.toLowerCase().replaceAll(
      ' ',
      '',
    ); // Normalize to match JSON
  }

  return normalized;
}

class FilterModal extends StatefulWidget {
  const FilterModal({Key? key}) : super(key: key);

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Updated filter options - changed conditions to tags
  final List<String> tags = [
    'Free Delivery',
    'Best Seller',
    'Most Popular',
    'Special Price',
  ];
  final List<String> genders = ['Men', 'Women', 'Kids'];

  // Split sizes for Men, Women, and Kids
  final Map<String, List<String>> sizes = {
    'Men': ['6', '7', '8', '9', '10', '11', '12'],
    'Women': ['5', '6', '7', '8', '9', '10'],
    'Kids': ['3', '4', '5', '6', '7', '8'],
  };

  // Selections
  final Set<String> selectedTags = {};
  final Set<String> selectedGenders = {};
  final Map<String, Set<String>> selectedSizes = {
    'Men': {},
    'Women': {},
    'Kids': {},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    ); // Fixed length to match tabs

    // Get current filters from parent if available
    final marketState = context.findAncestorStateOfType<_MarketScreenState>();
    if (marketState != null) {
      selectedTags.addAll(marketState.selectedTags);
      selectedGenders.addAll(marketState.selectedGenders);

      for (var gender in selectedSizes.keys) {
        selectedSizes[gender]!.addAll(marketState.selectedSizes[gender]!);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  // Clear all button
                  if (selectedTags.isNotEmpty ||
                      selectedGenders.isNotEmpty ||
                      selectedSizes.values.any((sizes) => sizes.isNotEmpty))
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedTags.clear();
                          selectedGenders.clear();
                          for (var gender in selectedSizes.keys) {
                            selectedSizes[gender]!.clear();
                          }
                        });
                      },
                      child: const Text('Clear All'),
                    ),
                ],
              ),
            ),
            // Tab bar
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: 'Tags'), // Changed from 'Condition' to 'Tags'
                Tab(text: 'Gender'),
                Tab(text: 'Size'),
              ],
            ),
            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChipTab(tags, selectedTags),
                  _buildChipTab(genders, selectedGenders),
                  _buildSizeTabs(),
                ],
              ),
            ),
            const Divider(height: 1),
            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // Apply filters and close modal
                        final marketState =
                            context
                                .findAncestorStateOfType<_MarketScreenState>();
                        if (marketState != null) {
                          marketState.updateFilters(
                            tags: Set.from(
                              selectedTags,
                            ), // Changed from conditions to tags
                            genders: Set.from(selectedGenders),
                            sizes: Map.fromEntries(
                              selectedSizes.entries.map(
                                (entry) =>
                                    MapEntry(entry.key, Set.from(entry.value)),
                              ),
                            ),
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Improved method to display size categories for Men, Women, and Kids with better alignment
  Widget _buildSizeTabs() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              sizes.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Improved alignment with GridView instead of Wrap
                      GridView.count(
                        crossAxisCount:
                            6, // 6 chips per row for better alignment
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.5, // Adjust for better proportions
                        children:
                            sizes[category]!.map((size) {
                              final isSelected = selectedSizes[category]!
                                  .contains(size);
                              return ChoiceChip(
                                label: Text(size, textAlign: TextAlign.center),
                                selected: isSelected,
                                selectedColor: Colors.black.withOpacity(0.8),
                                labelStyle: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedSizes[category]!.add(size);
                                    } else {
                                      selectedSizes[category]!.remove(size);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  // Improved chip tab with better spacing and alignment
  Widget _buildChipTab(List<String> options, Set<String> selectedSet) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 10, // Increased spacing
          runSpacing: 10, // Increased spacing
          alignment: WrapAlignment.start,
          children:
              options.map((option) {
                final isSelected = selectedSet.contains(option);
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: Colors.black.withOpacity(0.8),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedSet.add(option);
                      } else {
                        selectedSet.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ),
    );
  }
}
