import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Assuming iconsax is used

class KasutCreditScreen extends StatelessWidget {
  static const String routeName = '/kasut-credit'; // Define route name

  const KasutCreditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs: All, Credit In, Credit Out
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kasut Credit'), // Updated title
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Implement Top Up action
                        },
                        icon: const Icon(Iconsax.add_square),
                        label: const Text('Top Up'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue, // Example colors
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement Cash Out action
                        },
                        icon: const Icon(Iconsax.money_send),
                        label: const Text('Cash Out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(
                            color: Colors.blue,
                          ), // Example colors
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
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
