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
    // Removed final homeState = HomeStateProvider.of(context);

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

@override
Size get preferredSize => Size.fromHeight(kToolbarHeight + 50); // Height of AppBar + TabBar

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

    setState(() {
      if (selectedBrand == "All") {
        filteredShoes = ShoeData.shoes;
      } else {
        // Normalize brand names for filtering
        final normalizedSelectedBrand = _normalizeBrandName(selectedBrand);
        filteredShoes =
            ShoeData.shoes
                .where(
                  (shoe) =>
                      _normalizeBrandName(shoe.brand) ==
                      normalizedSelectedBrand,
                ) // Use normalized names for filtering
                .toList();
      }
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
            crossAxisCount = 3; // Tablets
            childAspectRatio = 0.65;
          } else if (constraints.maxWidth >= 900) {
            crossAxisCount = 4; // Desktops and large tablets
            childAspectRatio = 0.6;
          }

          return GridView.builder(
            itemCount: filteredShoes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final shoe = filteredShoes[index];
              return SneakerCard(sneaker: shoe);
            },
          );
        },
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

  // Updated filter options
  final List<String> conditions = ['Brand New', 'Used', 'Pre-Order', 'Express'];
  final List<String> genders = ['Men', 'Women', 'Kids'];

  // Split sizes for Men, Women, and Kids
  final Map<String, List<String>> sizes = {
    'Men': ['6', '7', '8', '9', '10', '11', '12'],
    'Women': ['5', '6', '7', '8', '9', '10'],
    'Kids': ['3', '4', '5', '6', '7', '8'],
  };

  // Selections
  final Set<String> selectedConditions = {};
  final Set<String> selectedGenders = {};
  final Map<String, Set<String>> selectedSizes = {
    'Men': {},
    'Women': {},
    'Kids': {},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // Ensures the entire modal is scrollable
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filter',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: const [
                Tab(text: 'Condition'),
                Tab(text: 'Gender'),
                Tab(text: 'Size'),
              ],
            ),
            // Use Flexible widget here to make TabBarView take the available space
            SizedBox(
              height:
                  MediaQuery.of(context).size.height *
                  0.5, // 50% of the screen height
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildChipTab(conditions, selectedConditions),
                  _buildChipTab(genders, selectedGenders),
                  _buildSizeTabs(),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle apply logic using selected* sets
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

  // Updated method to display size categories for Men, Women, and Kids
  Widget _buildSizeTabs() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Aligns the whole column to the left
      children:
          sizes.keys.map((category) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 16.0,
              ), // Spacing between each category
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Aligns the text to the left
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildChipTab(sizes[category]!, selectedSizes[category]!),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildChipTab(List<String> options, Set<String> selectedSet) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children:
            options.map((option) {
              final isSelected = selectedSet.contains(option);
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
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
    );
  }
}
