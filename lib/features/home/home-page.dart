import 'package:flutter/material.dart';
import 'package:tugasuts/features/blog/blog.dart';
import 'package:tugasuts/features/home/home-all.dart';
import 'package:tugasuts/features/home/home-search-bar.dart';

// State provider for shared state between HomeAppBar and HomeBody
class HomeStateProvider extends InheritedWidget {
  final TabController tabController;

  const HomeStateProvider({
    super.key,
    required this.tabController,
    required super.child,
  });

  static HomeStateProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<HomeStateProvider>();
    assert(result != null, 'No HomeStateProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(HomeStateProvider oldWidget) {
    return tabController != oldWidget.tabController;
  }
}

// Main state manager for HomePage components
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

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

  void onBottomNavTap(int index) {
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
  }

  @override
  Widget build(BuildContext context) {
    // Provide shared state to both AppBar and Body
    return HomeStateProvider(
      tabController: _tabController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const HomeAppBar(),
        body: const HomeBody(),
        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(color: Colors.white),
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
                  _selectedIndex == 1
                      ? Icons.article
                      : Icons.newspaper_outlined,
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
            selectedIconTheme: const IconThemeData(
              color: Colors.black,
              size: 26,
            ),
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
            onTap: onBottomNavTap,
          ),
        ),
      ),
    );
  }
}

// Separated AppBar with access to shared state
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(155);

  @override
  Widget build(BuildContext context) {
    // Get shared state from context
    final homeState = HomeStateProvider.of(context);

    return AppBar(
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
            controller: homeState.tabController, // Access shared controller
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
    );
  }
}

// Separated Body with access to shared state
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Get shared state from context
    final homeState = HomeStateProvider.of(context);

    return TabBarView(
      controller: homeState.tabController, // Access shared controller
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
