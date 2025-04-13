import 'package:flutter/material.dart';

class SellingScreen extends StatelessWidget {
  static const String routeName = '/selling'; // Define route name

  const SellingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selling'),
        leading: IconButton(
          // Add back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Selling Screen - UI Not Provided')),
    );
  }
}
