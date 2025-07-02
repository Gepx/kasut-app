import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Invitee {
  final String name;
  final bool joined;
  Invitee(this.name, {this.joined = false});
}

class InviteFriendScreen extends StatefulWidget {
  static const String routeName = '/invite-friend';

  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final String _referralCode = 'KAS1234';
  final List<Invitee> _invitees = [
    Invitee('Alex', joined: true),
    Invitee('Ben'),
    Invitee('Charlie'),
  ];

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: _referralCode));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Referral code copied'), backgroundColor: Colors.black),
    );
  }

  void _sharePlaceholder(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share via $platform coming soon'), backgroundColor: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Invite a Friend'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.person_add_alt, size: 80, color: Colors.black),
            const SizedBox(height: 16),
            const Text(
              'Invite friends & earn rewards',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your referral code and both of you will get special benefits!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _copyCode,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _referralCode,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                  onPressed: () => _sharePlaceholder('WhatsApp'),
                  icon: const Icon(Icons.share),
                  label: const Text('WhatsApp'),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.black, side: const BorderSide(color: Colors.black)),
                  onPressed: () => _sharePlaceholder('Instagram'),
                  icon: const Icon(Icons.share),
                  label: const Text('Instagram'),
                ),
                IconButton(
                  onPressed: _copyCode,
                  icon: const Icon(Icons.copy, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Friends invited', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            _invitees.isEmpty
                ? Column(
                    children: [
                      Icon(Icons.group_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('No invites yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final invitee = _invitees[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: Text(invitee.name[0].toUpperCase(), style: const TextStyle(color: Colors.black)),
                        ),
                        title: Text(invitee.name),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: invitee.joined ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            invitee.joined ? 'Joined' : 'Pending',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: _invitees.length,
                  ),
          ],
        ),
      ),
    );
  }
}
