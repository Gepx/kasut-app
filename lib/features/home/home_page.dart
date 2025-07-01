import 'package:flutter/material.dart';
import 'package:kasut/features/home/home_search_bar.dart';
import 'package:kasut/features/notif/notification_page.dart';
import 'package:kasut/features/home/home_all.dart';
import 'package:kasut/models/shoe_model.dart';
import 'package:kasut/features/home/components/brand_header.dart';
import 'package:kasut/features/home/components/brand_sneaker_grid.dart';

/// HomePage component following micro-frontend architecture
class HomePage extends StatelessWidget {
  final TabController tabController;
  final List<String> brands;

  const HomePage({
    super.key,
    required this.tabController,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    return HomeBody(
      tabController: tabController,
      brands: brands,
    );
  }
}

/// HomeAppBar component (micro-frontend)
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> brands;

  const HomeAppBar({
    super.key,
    required this.tabController,
    required this.brands,
  });

  @override
  Size get preferredSize => const Size.fromHeight(135);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const Expanded(child: HomeSearchBar()),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, size: 25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationPage(),
                        ),
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
        preferredSize: const Size.fromHeight(35),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 0.1),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 900;

              return TabBar(
                isScrollable: true,
                tabAlignment: isDesktop ? TabAlignment.center : TabAlignment.start,
                controller: tabController,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                tabs: brands.map((brand) => Tab(text: brand)).toList(),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.black,
                labelPadding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24.0 : 8.0,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// HomeBody component (micro-frontend)
class HomeBody extends StatelessWidget {
  final TabController tabController;
  final List<String> brands;

  const HomeBody({
    super.key,
    required this.tabController,
    required this.brands,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: brands.map((brand) {
        if (brand == "All") {
          return const CategoryAll();
        } else {
          return BrandTabContent(brand: brand);
        }
      }).toList(),
    );
  }
}

/// Brand tab content component (micro-frontend)
class BrandTabContent extends StatelessWidget {
  final String brand;

  const BrandTabContent({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Shoe>>(
      future: _loadBrandSneakers(brand),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading $brand sneakers: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return BrandContentWidget(brand: brand, sneakers: []);
        } else {
          return BrandContentWidget(
            brand: brand,
            sneakers: snapshot.data!,
          );
        }
      },
    );
  }

  Future<List<Shoe>> _loadBrandSneakers(String brand) async {
    try {
      if (ShoeData.shoes.isEmpty) {
        await ShoeData.loadFromAsset('assets/data/products.json');
      }
      return ShoeData.getByBrand(brand);
    } catch (e) {
      print('Error loading sneakers for brand $brand: $e');
      return [];
    }
  }
}

/// Brand content widget (micro-frontend)
class BrandContentWidget extends StatelessWidget {
  final String brand;
  final List<Shoe> sneakers;

  const BrandContentWidget({
    super.key,
    required this.brand,
    required this.sneakers,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        BrandHeader(brand: brand),
        _buildBrandTitle(context),
        const SizedBox(height: 16),
        sneakers.isEmpty
            ? EmptyBrandState(brand: brand)
            : BrandSneakerGrid(sneakers: sneakers),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildBrandTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        '$brand Sneakers',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 