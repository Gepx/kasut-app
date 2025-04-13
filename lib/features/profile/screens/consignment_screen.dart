import 'package:flutter/material.dart';

class ConsignmentScreen extends StatelessWidget {
  static const String routeName = '/consignment'; // Define route name

  const ConsignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consignment'),
        leading: IconButton(
          // Add back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Consignment Screen - UI Not Provided')),
    );
  }
}
