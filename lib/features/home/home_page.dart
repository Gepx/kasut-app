import 'package:flutter/material.dart';
import 'package:kasut/features/home/home_all.dart'; // Add import for CategoryAll
import 'package:kasut/features/home/home_search_bar.dart';
import 'package:kasut/features/notif/notification_page.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';
import 'package:kasut/features/single-product/single_product_page.dart'; // Import SingleProductPage

// List of brands for the tabs
final List<String> _brands = [
  "All",
  "Air Jordan",
  "Adidas",
  "OnClouds",
  "Nike",
  "Puma",
  "New Balance",
  "Asics",
  "Onisutka Tiger",
  "Salomon",
  "Yeezy",
];

// Brand info class to store descriptions
class BrandInfo {
  final String name;
  final String logoPath;
  final String description;

  const BrandInfo({
    required this.name,
    required this.logoPath,
    required this.description,
  });
}

// Brand descriptions map
final Map<String, BrandInfo> _brandInfo = {
  "Air Jordan": const BrandInfo(
    name: "Air Jordan",
    logoPath:
        "assets/brands/air_jordan.png", // Updated to use Air Jordan logo instead of Nike
    description:
        "Air Jordan is a sub-brand of Nike created for basketball legend Michael Jordan. Launched in 1984, the iconic silhouettes have transcended sports to become cultural symbols representing peak athletic performance and street style.",
  ),
  "Adidas": const BrandInfo(
    name: "Adidas",
    logoPath: "assets/brands/adidas.png",
    description:
        "Founded in 1949 in Germany, Adidas is one of the world's largest sportswear manufacturers known for its three stripes logo. The brand combines performance technology with street-style designs across footwear, apparel, and accessories.",
  ),
  "OnClouds": const BrandInfo(
    name: "OnClouds",
    logoPath: "assets/brands/oncloud.png",
    description:
        "On is a Swiss running sh oe company founded in 2010, known for its innovative CloudTec® cushioning technology. Their lightweight designs offer both comfort and performance for road and trail running.",
  ),
  "Nike": const BrandInfo(
    name: "Nike",
    logoPath: "assets/brands/nike.png",
    description:
        "Founded in 1964 as Blue Ribbon Sports, Nike has become the world's leading athletic footwear brand. Known for innovation in design and technology, Nike creates products for every type of athlete with its iconic Swoosh logo and 'Just Do It' slogan.",
  ),
  "Puma": const BrandInfo(
    name: "Puma",
    logoPath: "assets/brands/puma.png",
    description:
        "Established in 1948 in Germany, Puma is a global athletic and casual footwear brand known for blending sports performance with fashion-forward designs. Their iconic leaping cat logo represents speed and agility.",
  ),
  "New Balance": const BrandInfo(
    name: "New Balance",
    logoPath: "assets/brands/new_balance.png",
    description:
        "Founded in 1906, New Balance is renowned for its commitment to quality manufacturing and comfortable fit. The brand offers numeric widths in their shoes and maintains production facilities in the US and UK for premium lines.",
  ),
  "Asics": const BrandInfo(
    name: "Asics",
    logoPath: "assets/brands/asics.png",
    description:
        "Founded in 1949 in Japan, ASICS (Anima Sana In Corpore Sano - A Sound Mind in a Sound Body) specializes in performance running shoes with advanced cushioning technologies like GEL™ and FlyteFoam™ for injury prevention and comfort.",
  ),
  "Salomon": const BrandInfo(
    name: "Salomon",
    logoPath: "assets/brands/salomon.png",
    description:
        "Founded in 1947 in the French Alps, Salomon started as a ski equipment manufacturer. Today, they're known for technical trail running shoes and outdoor footwear designed for challenging terrains and weather conditions.",
  ),
  "Onisutka Tiger": const BrandInfo(
    name: "Onisutka Tiger",
    logoPath: "assets/brands/onisutka_tiger.png",
    description:
        "Founded in 1984, Onisutka Tiger is a brand known for its signature tiger design. Their shoes are known for their lightweight construction and durability, making them a popular choice for runners and athletes.",
  ),
  "Ortuseight": const BrandInfo(
    name: "Ortuseight",
    logoPath: "assets/brands/ortuseight.png",
    description:
        "Ortuseight is an Indonesian sports brand focusing on football and futsal footwear. Founded in 2018, they've quickly gained popularity in Southeast Asia for their quality and affordable performance shoes.",
  ),
  "Mizuno": const BrandInfo(
    name: "Mizuno",
    logoPath: "assets/brands/mizuno.png",
    description:
        "Founded in 1906 in Japan, Mizuno is known for premium quality sports equipment and footwear. Their running shoes feature Wave technology for cushioning and stability, popular among serious runners and athletes.",
  ),
  "Under Armour": const BrandInfo(
    name: "Under Armour",
    logoPath: "assets/brands/under_armour.png",
    description:
        "Founded in 1996, Under Armour began with moisture-wicking apparel and expanded to athletic footwear. Their HOVR™ cushioning and responsive designs cater to athletes looking for performance-driven shoes.",
  ),
  "Specs": const BrandInfo(
    name: "Specs",
    logoPath: "assets/brands/specs.png",
    description:
        "Specs is an Indonesian sports brand established in 1994, specializing in football, futsal, and running equipment. Known for their affordable yet durable products, they've become a popular choice in Southeast Asia.",
  ),
  "Yeezy": const BrandInfo(
    name: "Yeezy",
    logoPath: "assets/brands/yeezy.png",
    description:
        "Yeezy is a fashion collaboration between Kanye West and Adidas that began in 2015. Known for distinctive aesthetics, innovative materials, and limited releases, Yeezy sneakers have become highly collectible cultural icons.",
  ),
};
// --- End Placeholder Data ---

// Removed HomeStateProvider class definition

// HomePage accepts TabController from main.dart
class HomePage extends StatelessWidget {
  final TabController tabController;
  final List<String> brands; // Add brands parameter

  const HomePage({
    super.key,
    required this.tabController,
    required this.brands, // Require brands
  });

  // Removed _HomePageState class and its TabController management
  // Removed onBottomNavTap as navigation is handled in main.dart

  @override
  Widget build(BuildContext context) {
    // HomePage widget now simply returns the HomeBody.
    // The AppBar is constructed in main.dart where the TabController lives.
    // Pass the controller down to HomeBody
    return HomeBody(
      tabController: tabController,
      brands: brands,
    ); // Pass brands to HomeBody
  }
}

// Keep HomeAppBar requiring TabController
// Keep HomeBody as is
// Removed stray closing brace

// Updated AppBar to accept TabController
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> brands; // Add brands parameter

  const HomeAppBar({
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
                    icon: const Icon(Icons.notifications_outlined, size: 25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
                      );
                      // TODO: Implement notification action
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
            builder: (context, constraints) {
              // Determine if we're on desktop view based on width
              final isDesktop = constraints.maxWidth >= 900;

              return TabBar(
                isScrollable: true,
                tabAlignment:
                    isDesktop ? TabAlignment.center : TabAlignment.start,
                controller: tabController, // Use passed controller
                labelStyle: const TextStyle(
                  fontSize:
                      12, // Slightly increased font size for better readability
                  fontWeight: FontWeight.bold,
                ),
                // Generate tabs dynamically from the brands list
                tabs: brands.map((brand) => Tab(text: brand)).toList(),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.black,
                // Add tab padding for desktop view
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

// Data structure for categories
class CategoryInfo {
  final String title;
  final String imagePath;

  CategoryInfo({required this.title, required this.imagePath});
}

// HomeBody accepts TabController and brands list from HomePage
class HomeBody extends StatelessWidget {
  final TabController tabController;
  final List<String> brands; // Add brands parameter

  const HomeBody({
    super.key,
    required this.tabController,
    required this.brands, // Require brands
  });

  // Removed _HomeBodyState class and its internal TabController management

  @override
  Widget build(BuildContext context) {
    // Use TabBarView with the correctly accessed TabController
    return TabBarView(
      controller: tabController, // Use passed controller
      children:
          brands.map((brand) {
            // Use the passed brands list
            if (brand == "All") {
              // Show the "All" tab content from home_all.dart
              return const CategoryAll();
            } else {
              // For other brands, show filtered products by brand
              return FutureBuilder<List<Shoe>>(
                future: _loadBrandSneakers(brand),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading $brand sneakers: ${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _BrandTabContent(brand: brand, sneakers: []);
                  } else {
                    return _BrandTabContent(
                      brand: brand,
                      sneakers: snapshot.data!,
                    );
                  }
                },
              );
            }
          }).toList(),
    );
  }

  // Helper method to load sneakers by brand
  Future<List<Shoe>> _loadBrandSneakers(String brand) async {
    try {
      // Load products if needed
      if (ShoeData.shoes.isEmpty) {
        await ShoeData.loadFromAsset('assets/data/products.json');
      }

      // Use the new getByBrand method
      return ShoeData.getByBrand(brand);
    } catch (e) {
      print('Error loading sneakers for brand $brand: $e');
      return [];
    }
  }
}

// Widget for displaying brand-specific content
class _BrandTabContent extends StatelessWidget {
  final String brand;
  final List<Shoe> sneakers;

  const _BrandTabContent({required this.brand, required this.sneakers});

  @override
  Widget build(BuildContext context) {
    // Get brand info if available
    final brandInfo = _brandInfo[brand];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        // Brand banner with logo and description
        if (brandInfo != null)
          Container(
            height: 150,
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo on the left
                Container(
                  width: 120,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    brandInfo.logoPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.shopping_bag,
                        size: 50,
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),
                // Divider
                Container(height: 100, width: 1, color: Colors.grey[300]),
                // Brand description
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          brandInfo.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          brandInfo.description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          // Fallback if no brand info
          Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$brand Collection',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // Title for the brand
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '$brand Sneakers',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),

        // Sneaker grid or empty state
        sneakers.isEmpty
            ? _buildEmptyState(context)
            : _buildSneakerGrid(context, sneakers),

        const SizedBox(height: 20),
      ],
    );
  }

  // Empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No $brand sneakers found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new arrivals',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Sneaker grid builder
  Widget _buildSneakerGrid(BuildContext context, List<Shoe> sneakers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on available width
        int crossAxisCount = 2; // Default for phones
        double childAspectRatio = 0.55;

        // Responsive grid layout based on screen width
        if (constraints.maxWidth > 600 && constraints.maxWidth < 900) {
          crossAxisCount = 3; // Tablets
          childAspectRatio = 0.6;
        } else if (constraints.maxWidth >= 900 && constraints.maxWidth < 1200) {
          crossAxisCount = 4; // Small desktops
          childAspectRatio = 0.6;
        } else if (constraints.maxWidth >= 1200 &&
            constraints.maxWidth < 1600) {
          crossAxisCount = 7; // Large desktops
          childAspectRatio = 0.55;
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: sneakers.length,
          itemBuilder: (context, index) {
            return SneakerCard(
              sneaker: sneakers[index],
              onTap: () {
                // Navigate to product page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => SingleProductPage(shoe: sneakers[index]),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// --- Category Card Widget ---
class CategoryCard extends StatelessWidget {
  final CategoryInfo category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement category tap action
        print('Tapped on ${category.title}');
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12), // Padding inside the container
            decoration: BoxDecoration(
              color: Colors.white, // Light grey background
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            child: AspectRatio(
              aspectRatio: 1, // Make image container square
              child: Image.asset(
                category.imagePath,
                fit: BoxFit.contain, // Fit image within the container
                errorBuilder: (context, error, stackTrace) {
                  // Show placeholder icon if image fails to load
                  return Icon(
                    Icons.category,
                    color: Colors.grey[400],
                    size: 30,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            category.title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
