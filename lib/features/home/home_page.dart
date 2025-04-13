import 'package:flutter/material.dart';
import 'package:kasut/features/home/home_all.dart'; // Add import for CategoryAll
import 'package:kasut/features/home/home_search_bar.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';

// --- Placeholder Data ---
// Using placeholder network images for testing
final List<Shoe> _sampleSneakers = [
  Shoe(
    // id: '1', // Removed - Not in Shoe constructor
    name: 'Nike Dunk High By You',
    brand: 'Nike',
    price: 1850000,
    oldPrice: 2100000, // Added sample old price
    imageUrl:
        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/99486859-0ff3-46b4-949b-2d16af2ad421/custom-nike-dunk-high-by-you-shoes.png',
    // description: 'Customizable high-top sneaker.', // Removed
    // sizes: ['US 9', 'US 10', 'US 11'], // Removed
    // color: 'Multi-Color', // Removed
    // releaseDate: DateTime(2023, 1, 1), // Removed
  ),
  Shoe(
    // id: '2', // Removed
    name: 'Samba OG Shoes',
    brand: 'Adidas',
    price: 1500000,
    oldPrice: 1750000, // Added sample old price
    imageUrl:
        'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/7ed0855435194229a525aad6009a0497_9366/Samba_OG_Shoes_White_B75806_01_standard.jpg',
    // description: 'Classic indoor soccer shoe turned streetwear staple.', // Removed
    // sizes: ['US 8', 'US 9', 'US 10'], // Removed
    // color: 'White', // Removed
    // releaseDate: DateTime(2022, 8, 15), // Removed
  ),
  Shoe(
    // id: '3', // Removed
    name: 'MADE in USA 990v4',
    brand: 'New Balance',
    price: 2800000,
    imageUrl:
        'https://nb.scene7.com/is/image/NB/u990gr4_nb_02_i?pdpflexf2&qlt=80&fmt=webp&wid=440&hei=440',
    // description: 'Iconic running shoe known for comfort and style.', // Removed
    // sizes: ['US 9', 'US 9.5', 'US 10'], // Removed
    // color: 'Grey', // Removed
    // releaseDate: DateTime(2023, 5, 20), // Removed
  ),
  Shoe(
    // id: '4', // Removed
    name: 'GEL-KAYANO 30',
    brand: 'Asics',
    price: 2100000,
    imageUrl:
        'https://images.asics.com/is/image/asics/1011B792_100_SR_RT_GLB?\$sfcc-product\$', // Escaped $
    // description: 'Supportive running shoe for long distances.', // Removed
    // sizes: ['US 10', 'US 11', 'US 12'], // Removed
    // color: 'White/Blue', // Removed
    // releaseDate: DateTime(2023, 7, 1), // Removed
  ),
  Shoe(
    // id: '5', // Removed
    name: 'Air Jordan 1 Mid',
    brand: 'Air Jordan',
    price: 1950000,
    imageUrl:
        'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/air-jordan-1-mid-shoes-86f1ZW.png',
    // description: 'Mid-top version of the iconic AJ1.', // Removed
    // sizes: ['US 8', 'US 9', 'US 10'], // Removed
    // color: 'Black/Red', // Removed
    // releaseDate: DateTime(2023, 3, 10), // Removed
  ),
  Shoe(
    // id: '6', // Removed
    name: 'Puma Suede Classic XXI',
    brand: 'Puma',
    price: 1100000,
    imageUrl:
        'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_600,h_600/global/374915/01/sv01/fnd/IND/fmt/png/Suede-Classic-XXI-Men\'s-Sneakers',
    // description: 'Timeless suede sneaker.', // Removed
    // sizes: ['US 9', 'US 10', 'US 11'], // Removed
    // color: 'Red/White', // Removed
    // releaseDate: DateTime(2022, 11, 5), // Removed
  ),
];

// List of brands for the tabs
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
        "assets/brands/nike.png", // Using Nike logo since it's a Nike sub-brand
    description:
        "Air Jordan is a sub-brand of Nike created for basketball legend Michael Jordan. Launched in 1984, the iconic silhouettes have transcended sports to become cultural symbols representing peak athletic performance and street style.",
  ),
  "Adidas": const BrandInfo(
    name: "Adidas",
    logoPath: "assets/brands/adidas.png",
    description:
        "Founded in 1949 in Germany, Adidas is one of the world's largest sportswear manufacturers known for its three stripes logo. The brand combines performance technology with street-style designs across footwear, apparel, and accessories.",
  ),
  "onCloud": const BrandInfo(
    name: "onCloud",
    logoPath: "assets/brands/oncloud.png",
    description:
        "On is a Swiss running shoe company founded in 2010, known for its innovative CloudTec® cushioning technology. Their lightweight designs offer both comfort and performance for road and trail running.",
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
    logoPath: "assets/brands/asics.png", // This logo may need to be added
    description:
        "Founded in 1949 in Japan, ASICS (Anima Sana In Corpore Sano - A Sound Mind in a Sound Body) specializes in performance running shoes with advanced cushioning technologies like GEL™ and FlyteFoam™ for injury prevention and comfort.",
  ),
  "Salomon": const BrandInfo(
    name: "Salomon",
    logoPath: "assets/brands/salomon.png", // This logo may need to be added
    description:
        "Founded in 1947 in the French Alps, Salomon started as a ski equipment manufacturer. Today, they're known for technical trail running shoes and outdoor footwear designed for challenging terrains and weather conditions.",
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
    logoPath: "assets/brands/yeezy.png", // This logo may need to be added
    description:
        "Yeezy is a fashion collaboration between Kanye West and Adidas that began in 2015. Known for distinctive aesthetics, innovative materials, and limited releases, Yeezy sneakers have become highly collectible cultural icons.",
  ),
};
// --- End Placeholder Data ---

// Removed HomeStateProvider class definition

// HomePage accepts TabController from main.dart
class HomePage extends StatelessWidget {
  final TabController tabController; // Add controller parameter

  const HomePage({
    super.key,
    required this.tabController, // Require controller
  });

  // Removed _HomePageState class and its TabController management
  // Removed onBottomNavTap as navigation is handled in main.dart

  @override
  Widget build(BuildContext context) {
    // HomePage widget now simply returns the HomeBody.
    // The AppBar is constructed in main.dart where the TabController lives.
    // Pass the controller down to HomeBody
    return HomeBody(tabController: tabController);
  }
}

// Keep HomeAppBar requiring TabController
// Keep HomeBody as is
// Removed stray closing brace

// Updated AppBar to accept TabController
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController; // Add controller parameter

  const HomeAppBar({
    super.key,
    required this.tabController,
  }); // Require controller

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
          child: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            controller: tabController, // Use passed controller
            labelStyle: const TextStyle(
              fontSize: 10, // Keep style or adjust
              fontWeight: FontWeight.bold,
            ),
            // Generate tabs dynamically from the _brands list
            tabs: _brands.map((brand) => Tab(text: brand)).toList(),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.black,
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

// List of categories based on the screenshot
final List<CategoryInfo> _categories = [
  CategoryInfo(title: 'Men', imagePath: 'assets/home/mens.png'),
  CategoryInfo(title: 'Women', imagePath: 'assets/home/womens.png'),
  CategoryInfo(title: 'Kids', imagePath: 'assets/home/kids.png'),
  CategoryInfo(title: 'Air Jordan', imagePath: 'assets/home/airjordan.png'),
  CategoryInfo(title: 'OnClouds', imagePath: 'assets/home/oncloud.png'),
  CategoryInfo(title: 'Samba', imagePath: 'assets/home/samba.png'),
  CategoryInfo(title: 'Asics', imagePath: 'assets/home/asics.png'),
  CategoryInfo(title: 'New Arrivals', imagePath: 'assets/home/arrivals.png'),
];

// HomeBody accepts TabController from HomePage
class HomeBody extends StatelessWidget {
  // Changed to StatelessWidget
  final TabController tabController; // Add controller parameter

  const HomeBody({
    super.key,
    required this.tabController, // Require controller
  });

  // Removed _HomeBodyState class and its internal TabController management

  @override
  Widget build(BuildContext context) {
    // Use TabBarView with the correctly accessed TabController
    return TabBarView(
      controller: tabController, // Use passed controller
      children:
          _brands.map((brand) {
            if (brand == "All") {
              // Show the "All" tab content from home_all.dart
              return const CategoryAll();
            } else {
              // For other brands, show filtered products
              // Filter the sneakers based on the brand
              final filteredSneakers =
                  ShoeData.shoes.where((shoe) => shoe.brand == brand).toList();

              // Show brand-specific content
              return _BrandTabContent(brand: brand, sneakers: filteredSneakers);
            }
          }).toList(),
    );
  }
}

// Widget for displaying brand-specific content
class _BrandTabContent extends StatelessWidget {
  final String brand;
  final List<Shoe> sneakers;

  const _BrandTabContent({required this.brand, required this.sneakers});

  @override
  Widget build(BuildContext context) {
    final brandInfo = _brandInfo[brand];

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        // Updated brand banner with logo on left and description on right
        if (brandInfo != null)
          Container(
            height: 150, // Increased height to prevent overflow
            width: double.infinity,
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
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
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Ensure vertical centering
              children: [
                // Logo on the left - made bigger
                Container(
                  width: 120, // Increased width for larger logo
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(brandInfo.logoPath, fit: BoxFit.contain),
                ),
                // Divider
                Container(height: 100, width: 1, color: Colors.grey[300]),
                // Text on the right
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

        // Sneaker grid for this brand
        sneakers.isEmpty
            ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'No $brand sneakers found',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
            : _buildSneakerGrid(context, sneakers),

        const SizedBox(height: 20),
      ],
    );
  }

  // Reuse the sneaker grid builder from HomeBody
  Widget _buildSneakerGrid(BuildContext context, List<Shoe> sneakers) {
    if (sneakers.isEmpty) {
      return const Center(child: Text('No sneakers found for this brand.'));
    }

    // Updated grid layout with better height calculation
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.55, // Adjusted aspect ratio for better height
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: sneakers.length,
      itemBuilder: (context, index) {
        return SneakerCard(
          sneaker: sneakers[index],
          // Let SneakerCard determine its own height
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
              color: Colors.grey[100], // Light grey background
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
