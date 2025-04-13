import 'package:flutter/material.dart';

class BuyingScreen extends StatelessWidget {
  static const String routeName = '/buying'; // Define route name

  const BuyingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buying'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: const TabBar(
            labelColor: Colors.black, // Or your app's primary text color
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black, // Or your app's accent color
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Content for Active tab
            Center(child: Text('No Result Found')),
            // Content for Completed tab
            Center(child: Text('No Result Found')),
            // Content for Cancelled tab
            Center(child: Text('No Result Found')),
          ],
        ),
      ),
    );
  }
}
