import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Assuming iconsax is used

class SellerCreditScreen extends StatelessWidget {
  static const String routeName = '/seller-credit'; // Define route name

  const SellerCreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs: All, Credit In, Credit Out
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seller Credit'), // Correct title
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // No info icon shown in Image 7
          // actions: [
          //   IconButton(
          //     icon: const Icon(Iconsax.info_circle),
          //     onPressed: () { /* TODO: Implement info action */ },
          //   ),
          // ],
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Credit In'),
              Tab(text: 'Credit Out'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Balance Section
            Container(
              padding: const EdgeInsets.all(20.0),
              color: Colors.grey[100], // Light background for balance section
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Balance',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rp 0', // Static balance
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Only Cash Out button
                  Center(
                    // Center the single button
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement Cash Out action
                      },
                      icon: const Icon(Iconsax.money_send),
                      label: const Text('Cash Out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(
                          color: Colors.black,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                      ),
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
                  // Content for Credit In tab
                  Center(child: Text('No Result Found')),
                  // Content for Credit Out tab
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
