import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // Assuming iconsax is used for the voucher icon

class MyVoucherScreen extends StatelessWidget {
  static const String routeName = '/my-voucher'; // Define route name

  const MyVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Voucher'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Iconsax.message_question,
            ), // Or appropriate help icon
            onPressed: () {
              // TODO: Implement help action
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Iconsax.ticket_discount, // Or appropriate voucher icon
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Vouchers Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You currently do not have any vouchers.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                // TODO: Implement help action if needed here too, or remove
              },
              child: const Text(
                'Need help? Contact Kasut Care', // Updated text
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue, // Or your app's link color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
