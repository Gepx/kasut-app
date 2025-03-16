import 'package:flutter/material.dart';
import 'package:tugasuts/features/blog/blog.dart';
import 'package:tugasuts/features/home/home-all.dart';
import 'package:tugasuts/features/home/home-search-bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0; // Add this to track selected index

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(child: HomeSearchBar()),
                    const Icon(Icons.notification_important, size: 25),
                  ],
                ),
                const SizedBox(height: 20),
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
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              controller: _tabController,
              labelStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Air Jordan"),
                Tab(text: "Adidas"),
                Tab(text: "onCloud"),
                Tab(text: "Nike"),
                Tab(text: "Puma"),
                Tab(text: "Yeezy"),
                Tab(text: "Asics"),
                Tab(text: "Salomon"),
                Tab(text: "Onitsuka Tiger"),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.black,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CategoryAll(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
          _buildProductsGrid(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70, // Increase height of the navigation bar
        decoration: BoxDecoration(color: Colors.white),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          iconSize: 24, // Slightly larger icons
          backgroundColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1 ? Icons.article : Icons.newspaper_outlined,
              ),
              label: 'Blog',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2
                    ? Icons.shopping_bag
                    : Icons.shopping_bag_outlined,
              ),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? Icons.favorite : Icons.favorite_border,
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 4 ? Icons.person : Icons.person_outline,
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedIconTheme: const IconThemeData(color: Colors.black, size: 26),
          unselectedIconTheme: const IconThemeData(
            color: Colors.black,
            size: 24,
          ),
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });

            switch (index) {
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Blog()),
                );
                break;
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 10, // Sample count
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  width: double.infinity,
                  child: const Center(
                    child: Icon(Icons.shopping_bag_outlined, size: 50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '\$199.99',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
