import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Assuming iconsax is used

class KasutPointsScreen extends StatelessWidget {
  static const String routeName = '/kasut-points'; // Define route name

  const KasutPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs: All, Points In, Points Out
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kasut Points'), // Updated title
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.info_circle), // Info icon
              onPressed: () {
                // TODO: Implement info action
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Points In'),
              Tab(text: 'Points Out'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Points Balance Section
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 20.0,
              ), // Adjusted padding
              color: Colors.grey[100], // Light background
              child: Row(
                // Use Row for icon and text
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Iconsax.coin, // Points icon
                    size: 40,
                    color: Colors.orange, // Example color
                  ),
                  SizedBox(width: 15),
                  Text(
                    '0 Points', // Static points balance
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Tab Content Section
            const Expanded(
              child: TabBarView(
                children: [
                  // Content for All tab
                  Center(child: Text('No Result Found')),
                  // Content for Points In tab
                  Center(child: Text('No Result Found')),
                  // Content for Points Out tab
                  Center(child: Text('No Result Found')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
