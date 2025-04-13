import 'package:flutter/material.dart';

class InviteFriendScreen extends StatelessWidget {
  static const String routeName = '/invite-friend'; // Define route name

  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite a Friend'),
        leading: IconButton(
          // Add back button
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Invite a Friend Screen Placeholder')),
    );
  }
}
