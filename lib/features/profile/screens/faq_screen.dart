import 'package:flutter/material.dart';
import 'package:kasut/features/faq/faq_page.dart';

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
      body: FAQPage(),
    );
  }
}
