import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  static const String routeName = '/faq'; // Define route name

  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        leading: IconButton(
          // Add back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('FAQ Screen Placeholder')),
    );
  }
}
