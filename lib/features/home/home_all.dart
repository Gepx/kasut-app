import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kasut/features/single-product/single_product_page.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/widgets/sneaker_card.dart';

// BoxData class for the category boxes
class BoxData {
  final String title;
  final String image;

  const BoxData({required this.title, required this.image});
}

// List of box data items for the grid
final List<BoxData> listData = [
  BoxData(title: "Mens", image: "assets/home/mens.png"),
  BoxData(title: "Womens", image: "assets/home/womens.png"),
  BoxData(title: "Kids", image: "assets/home/kids.png"),
  BoxData(title: "2025 Arrivals", image: "assets/home/arrivals.png"),
  BoxData(title: "Air Jordan", image: "assets/home/airjordan.png"),
  BoxData(title: "Asics", image: "assets/home/asics.png"),
  BoxData(title: "onCloud", image: "assets/home/oncloud.png"),
  BoxData(title: "Samba", image: "assets/home/samba.png"),
];

// Sample featured sneakers - you can use the same data from home_page.dart or import from a model
final List<Shoe> _featuredSneakers = ShoeData.shoes.take(6).toList();
final List<Shoe> _popularSneakers = ShoeData.shoes.skip(6).take(4).toList();

class CategoryAll extends StatelessWidget {
  const CategoryAll({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive layout
    final double screenWidth = MediaQuery.of(context).size.width;
    const double breakpoint = 800.0; // Breakpoint for switching images

    // Define image lists for different screen sizes
    final List<String> mobileImageUrls = [
      "https://www.topsandbottomsusa.com/cdn/shop/articles/Air_Jordan_1_Retro_High_OG_Midnight_Navy_Banner-608005.png?v=1739831182&width=1200",
      "https://images.pexels.com/photos/10963373/pexels-photo-10963373.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
    ];

    final List<String> desktopImageUrls = [
      "https://via.placeholder.com/1200x400.png/CCCCCC/969696?text=Wide+Banner+1",
      "https://via.placeholder.com/1200x400.png/AAAAAA/808080?text=Wide+Banner+2",
      "https://via.placeholder.com/1200x400.png/DDDDDD/A0A0A0?text=Wide+Banner+3",
    ];

    // Select the appropriate image list based on screen width
    final List<String> selectedImageUrls =
        screenWidth < breakpoint ? mobileImageUrls : desktopImageUrls;

    // Wrap the entire scrollable content in a white container
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 2),
                ),
              ),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 350.0,
                  autoPlay: true,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                ),
                items:
                    selectedImageUrls.map((url) {
                      return Image.network(
                        url,
                        width: double.infinity,
                        height: 350,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        // Optional: Add error and loading builders for better UX
                        loadingBuilder: (
                          BuildContext context,
                          Widget child,
                          ImageChunkEvent? loadingProgress,
                        ) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        },
                        errorBuilder: (
                          BuildContext context,
                          Object exception,
                          StackTrace? stackTrace,
                        ) {
                          return Container(
                            // Placeholder for error
                            width: double.infinity,
                            height: 350,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Categories Grid - 2 rows of 4 items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Define breakpoint and sizes
                      const double breakpoint = 800.0;
                      final bool isLargeScreen =
                          constraints.maxWidth >= breakpoint;
                      final int crossAxisCount = isLargeScreen ? 8 : 4;
                      final double imageSize = isLargeScreen ? 80.0 : 60.0;

                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          8,
                          (index) => Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  listData[index].image,
                                  width: imageSize, // Use dynamic size
                                  height: imageSize, // Use dynamic size
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  listData[index].title,
                                  style: const TextStyle(fontSize: 10),
                                  textAlign:
                                      TextAlign
                                          .center, // Center text for better look
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Featured Sneakers
            // Featured Sneakers
            Container(
              color: Colors.white, // Set background to white
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ), // Add vertical padding
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Sneakers',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to view all featured sneakers
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Define a breakpoint for switching layouts
                        const double breakpoint = 600.0;

                        if (constraints.maxWidth < breakpoint) {
                          // Mobile layout: Horizontal ListView
                          return SizedBox(
                            height: 320, // Fixed height for the horizontal list
                            width: constraints.maxWidth, // Explicitly set width
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _featuredSneakers.length,
                              itemBuilder: (context, index) {
                                final sneaker = _featuredSneakers[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? 0 : 8,
                                    right: 8,
                                  ),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.45, // Control card width for mobile
                                    child: SneakerCard(sneaker: sneaker),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          // Tablet/Desktop layout: GridView
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      250, // Max width for each item
                                  childAspectRatio:
                                      0.6, // Adjust aspect ratio as needed
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                            itemCount: _featuredSneakers.length,
                            itemBuilder: (context, index) {
                              final sneaker = _featuredSneakers[index];
                              return SneakerCard(sneaker: sneaker);
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Popular Section
            // Popular Section
            Container(
              color: Colors.white, // Set background to white
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
              ), // Add vertical padding
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Right Now',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Navigate to view all popular sneakers
                          },
                          child: const Text(
                            'View All',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Define a breakpoint for switching layouts
                        const double breakpoint = 600.0;

                        if (constraints.maxWidth < breakpoint) {
                          // Mobile layout: Horizontal ListView
                          return SizedBox(
                            height: 320, // Fixed height for the horizontal list
                            width: constraints.maxWidth, // Explicitly set width
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _popularSneakers.length,
                              itemBuilder: (context, index) {
                                final sneaker = _popularSneakers[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? 0 : 8,
                                    right: 8,
                                  ),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.45, // Control card width for mobile
                                    child: SneakerCard(sneaker: sneaker),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          // Tablet/Desktop layout: GridView
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent:
                                      250, // Max width for each item
                                  childAspectRatio:
                                      0.6, // Adjust aspect ratio as needed
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                            itemCount: _popularSneakers.length,
                            itemBuilder: (context, index) {
                              final sneaker = _popularSneakers[index];
                              return SneakerCard(sneaker: sneaker);
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Single Product Button Demo
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('View Single Product Demo'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SingleProductPage(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // _buildSneakerGrid removed as it's no longer used
}
